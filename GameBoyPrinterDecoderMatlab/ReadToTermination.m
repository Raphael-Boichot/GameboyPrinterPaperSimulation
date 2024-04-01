function [char_array] = ReadToTermination (srl_handle, term_char)
% parameter term_char is optional, if not specified
% then CR = 'r' = 13dec is the default.
if (nargin == 1)
    term_char = 13;
end
not_terminated = true;
i = 1;
int_array = uint8(1);
while not_terminated
    val = fread(srl_handle, 1);
    if(val == term_char)
        not_terminated = false;
    end
    % Add char received to array
    int_array(i) = val;
    i = i + 1;
end
% Change int array to a char array and return a string array
char_array = char(int_array);
endfunction