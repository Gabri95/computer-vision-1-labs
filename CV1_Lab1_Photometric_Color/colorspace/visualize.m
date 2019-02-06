function visualize(input_image, colorspace)

    img_len = size(input_image(1,1,:));
    img_len = img_len(end);
    
    if img_len == 3
        % disp(colorspace);
        figure
        
        subplot(2, 2, 1); 
        imshow(input_image);
        title(colorspace);
        
        subplot(2, 2, 2); 
        imshow(input_image(:,:,1));
        title('channel 1');
        
        subplot(2, 2, 3); 
        imshow(input_image(:,:,2));
        title('channel 2');
        
        subplot(2, 2, 4); 
        imshow(input_image(:,:,3));
        title('channel 3');
        
        pause(1);
    else
        figure
        
        for i = drange(1 : img_len)
            subplot(2, 2, i); 
            imshow(input_image(:,:,i));
            title(colorspace);
            
            pause(1); 
        end
    end

end

