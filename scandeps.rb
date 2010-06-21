#!/usr/bin/ruby
# 
# TODO:
# - Proper configuration using jobname. (E.g. get jobname from base name of
#   dependency file if not specified on command line)
# - Skip generated files from list like the following:
# - Allow the user to specify a list of additional dependencies (so that
#   undetected depencies can be added manually).

require 'optparse'
require 'mk/tempdir'

$opts = {}
$opts[:verbose] = false
$opts[:help]    = false
$opts[:jobname] = ''  
$opts[:compress] = 'tar cvfz $CMPTARGET $CMPSOURCES'
$opts[:sink] = '> /dev/null'
$opts[:extradeps] = '' # File containing additional dependencies.
$opts[:generated_exts] = %w(aux idx ind lof lot out toc bbl blg)

def parse_options
    op = OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename(__FILE__)} [options] <depfile>"

        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
            $opts[:verbose] = true
        end

        opts.on("-h", "Display help") { |v| $opts[:help] = true}

        opts.on("-o", "--output FILE", "Output file") do |f|
            $opts[:output] = f
        end

        opts.on("-e", "--extradeps FILE", "File containing additional deps") \
            do |file|
            $opts[:extradeps] = file
            end
    end
    op.parse!

    if $opts[:help]
        $stderr.puts(op.to_s)
        exit(1)
    end
end

def debug(msg)
    return unless $opts[:verbose]

    syncstate = $stderr.sync
    $stderr.sync = true
    $stderr.puts("DEBUG: #{msg}")
    $stderr.sync = syncstate
end

def warning(msg)
    $stderr.puts("Warning: #{msg}")
end

# Remove extension from filename (last dot plus everything that follows)
def remove_ext(fn)
    fn.sub(/\.[^.]*$/, '')
end

def read_extradeps()
    files = []
    fn = $opts[:extradeps]
    open(fn, 'r') do |fin|
        fin.each do |line|
            line.chomp!
            # Remove comments and skip empty lines
            line.sub!(/\s*#.*$/, '')
            next if line =~ /^\s*$/

            # Treat each line as a glob term
            Dir.glob(line) do |f|
                files.push(Pathname.new(f))
                debug("Adding additional dependency #{f}")
            end
        end
    end

    files
end

def read_depfile(fn)
    depfiles = [] # Contains fully qualified names of dependency files

    in_deps = false
    open(fn, "r") do |fin|
        fin.each do |line|
            line.chomp!
            in_deps = true if (line =~ /^===Rules:\s*$/)

            if in_deps and line =~ /^\s*'([^' ]*)'\s*$/
                # If a file is not found, skip it and issue a warning.
                dep = $1
                unless File.exist?(dep)
                    warning("File '#{dep}' does not exist, wrongly parsed?")
                    next
                end
                depfiles.push(Pathname.new($1.sub(/^\.\//, '')))
            end
        end
    end
    depfiles
end


def get_dependencies(deplistfile)

    # Read the dependencies from the provided dependency file.
    depfiles = read_depfile(deplistfile)

    # Add extra dependencies if they were specified.
    depfiles.concat(read_extradeps()) if $opts[:extradeps] != ""

    # Return only those files that are not generated
    return depfiles.find_all do |f|
        not ($opts[:generated_exts].any? { |ext| f.to_s =~ /\.#{ext}$/ })
    end
end


def get_subdirs(depfiles)
    subdirs = {}
    depfiles.each do |qn|
        # For relative paths, check if they are in a subdirectory.
        unless qn.absolute?
            if qn.dirname.to_s != '.' and qn.dirname.to_s != ""
                # This file is in a proper subdirectory.
                subdirs[qn] = qn.dirname
            end
        end
    end
    subdirs
end

parse_options

if ARGV.length != 1
    error("Syntax error.")
    exit(1)
end

# Get jobname from argument unless it is already defined.
$opts[:jobname] = remove_ext(ARGV.first) if ($opts[:jobname] = "")

# Get dependency list file from command line.
depfiles = get_dependencies(ARGV.first)

# Get subdirectories for relative paths
subdirs = get_subdirs(depfiles)

MK::TempDir.open() do |tmpdir|
    basedir = tmpdir + Pathname.new($opts[:jobname])
    FileUtils.mkdir(basedir, :mode => 0700)

    depfiles.each do |file|
        targetdir = ""
        if subdirs[file]
            # Create subdirectories and set target directory
            targetdir = basedir + subdirs[file]
            unless targetdir.exist?
                debug("Creating directory #{targetdir}")
                FileUtils.mkdir_p(targetdir)
            end
        else
            # target directory is root of temp directory
            targetdir = basedir
        end

        # Copy file to destination
        debug("COPYING #{file} -> #{targetdir}")
        FileUtils.cp(file, targetdir)
    end

    arcname = $opts[:output] || 
        Pathname.new(".").realpath + ($opts[:jobname] + ".tar.gz")
    ENV['CMPTARGET'] = File.expand_path(arcname)
    ENV['CMPSOURCES'] = $opts[:jobname]

    debug("Creating archive #{arcname} from #{$opts[:jobname]}")
    Dir.chdir(tmpdir) do
        retval = $opts[:verbose] ? system($opts[:compress]) :
            system($opts[:compress] + $opts[:sink])

        if retval == false
            raise "Could not create archive: #$?"
        end
    end

    puts "Created archive #{arcname}."

end

