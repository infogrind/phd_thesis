#!/usr/bin/ruby
#
# This script looks at all .m files in the current directory and its
# subdirectories (recursively) and parses all "classdef" lines. It builds a tree
# of the class hierarchy implied and displays this tree, for all classes that
# have the 'handle' class as their original ancestor.

require 'optparse'
require 'pathname'
require 'find'

# Default options
$options = {
    'verbose'   => false,
}

def make_option_parser
    opts = OptionParser.new
    opts.on("-v") {|val| $options['verbose'] = true}
    opts.on("-h", "--help") { |val| usage(); exit(1) }

    opts
end

def usage
    $stderr.puts(make_option_parser().to_s)
end

def parse_options
    opts = make_option_parser
    opts.parse(*ARGV)
end



# Debug info display routine
def debug(msg)
    $stderr.puts("DEBUG: #{msg}") if $options['verbose']
end

# Print a warning message
def warning(msg) $stderr.puts("Warning: #{msg}") end

begin
    parse_options
rescue OptionParser::InvalidOption
    $stderr.puts "Syntax error"
    usage()
    exit(1)
end


# Main code begins here
#
# Initialize empty class tree.
$classtree = {}

# Extract the class definition from the file f and add the information to the
# class tree.
def extract_class(f)
    pat = Regexp.new('^\s*classdef\s+([^\s]*)\s*<\s*([^\s]*)')
    File.open(f) do |file|
        file.each_line do |l|
            if l =~ pat 
                c = $1
                b = $2
                add_to_tree(c, b)
                break
            end
        end
    end
end

def add_to_tree(c, b)
    if !$classtree[c]
        debug("Found class #{c} for the first time, adding empty list.")
        $classtree[c] = []
    end

    # If entry for base class already exists, add c to its children. Otherwise
    # create a new entry for b, containing a list with c as its single element.
    if $classtree[b]
        $classtree[b].push(c)
    else
        $classtree[b] = [c]
    end
end

# Prints the tree whose root has name n with an indent of i space characters.
def print_tree(n, i = 0)
    i.times { print " " }
    puts "+-#{n}"
    $classtree[n].sort.each { |c| print_tree(c, i+2) }
end

def print_tex_tree(n, i = 0)
    def spaces(i)
        i.times { print " " }
    end

    # Do nothing if the tree has no children. 
    if $classtree[n].length == 0
        spaces(i); puts "\\emph{no children}"
        return
    end

    spaces(i); puts "\\begin{enumerate}"
    $classtree[n].sort.each do |c|
        spaces(i+2); puts "\\item \\texttt{#{c}}:"
        print_tex_tree(c, i+4)
    end
    spaces(i); puts "\\end{enumerate}"


end

Find.find(".") do |f|
    if File.file?(f) and f =~ /.m$/
        extract_class(f)
    end
end

print_tree("handle")
#print_tex_tree("Scheme")
