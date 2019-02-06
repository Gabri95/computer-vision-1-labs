function [images] = read_images(file_path)
    fid = fopen(file_path);
    tline = fgetl(fid);
    images = [];
    count = 1;
    while ischar(tline)
        images = [images; string([tline '.jpg'])];
        tline = fgetl(fid);
        count = count + 1;
    end
end

