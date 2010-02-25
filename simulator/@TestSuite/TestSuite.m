classdef TestSuite
    %TESTSUITE Provides test routines.
    %   This class provides a number of static test_* functions that test
    %   various things. The test functions have been put in this class mainly to
    %   group them. 

    methods (Access = 'public', Static = true)
        test_output_modules()
        test_schemes()
    end
    
end

