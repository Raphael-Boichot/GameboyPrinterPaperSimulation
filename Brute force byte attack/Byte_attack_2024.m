%this code makes a recursive search with a byte sequence in folders (the search is recursive)
%it then stores the files with the byte sequence in them in the .\output folder
%was made initially around 2021, not sure when exactly, this is an updated version
clc
clear
disp('-----------------------------------------------------------')
disp('|Beware, this code is for Matlab ONLY !!!                 |')
disp('-----------------------------------------------------------')
mkdir('.\output_folder');
delete('.\output_folder\*');
listing = dir('.\search_folder\**\*.*');
sequence = [0x88 0x33 0x01 0x00 0x00 0x00 0x01];%printer library signature (among others)
%sequence=('printer')%some ASCII keyword can work too

disp(sequence)
disp([num2str(length(listing)),' files found'])
for i=1:1:length(listing)%just replace for by parfor if you own the required library
    name=[listing(i).folder,'\',listing(i).name];
    fid = fopen([listing(i).folder,'\',listing(i).name],'r');
    if not(fid==-1)
        a=fread(fid);
        fclose(fid);
        a=a';
        if rem(i,10000)==0
            disp([num2str(i),' files analysed'])
        end
        if not(isempty(strfind(a,sequence)))
            disp(name)
            copyfile([listing(i).folder,'\',listing(i).name],'.\output_folder');
        end
    end
end
disp('End of byte attack')
