function write_video(video_file_path, block, img_array)
    vid = VideoWriter([video_file_path '/' block], 'MPEG-4');
    vid.FrameRate = 24;
    open(vid)

    for i = 1:length(img_array)
        writeVideo(vid, img_array{i});
    end

    close(vid)
end
