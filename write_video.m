function write_video(video_file_path, block, img_array)
    writer = VideoWriter([video_file_path '/' block], 'MPEG-4');
    writer.FrameRate = 30;
    open(writer)

    for i = 1:length(img_array(1,1,1,:))
        writeVideo(writer, img_array(:,:,:,i));
    end

    close(writer)
end
