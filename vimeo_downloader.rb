require 'pry'
require 'open-uri'
require_relative './vimeo_service.rb'
require_relative './lecture.rb'
require_relative './course.rb'

def sanitize(filename)
  bad_chars = [ '/', '\\', '?', '%', '*', ':', '|', '"', '<', '>', '.', ' ' ]
  bad_chars.each do |bad_char|
    filename.gsub!(bad_char, '_')
  end
  filename
end

def download_all_videos_from_course(course_id)
  course = Course.new(course_id)
  course.get_course_info

  folder_name = sanitize("#{course.id} - #{course.title}")
  Dir.mkdir(folder_name) unless File.exists?(folder_name)

  course.lectures.each do |lecture|
    puts "Starting to download #{lecture.id} - #{lecture.title}"
    vimeo_service = VimeoService.new(lecture.vimeo_video_id)
    video_info = vimeo_service.get_video_info
    video_link = ''

    video_info['download'].sort_by{ |v| v['width'] }.reverse.each do |v|
      next unless v['type'] == 'video/mp4'
      video_link = v['link']
      break
    end

    video_file = open(video_link)
    IO.copy_stream(video_file, "./#{folder_name}/#{sanitize(lecture.video_file_name)}.mp4")
    puts "Downloaded: #{lecture.id} - #{lecture.title}"
  end
end

begin
  f1 = File.open('course_ids.txt', 'r')
  f2 = File.open('downloaded.txt', 'w')

  f1.each_line do |line|
    course_id = line.to_i
    download_all_videos_from_course(course_id)
    f2.puts course_id
  end
ensure
  f1.close
  f2.close
end
