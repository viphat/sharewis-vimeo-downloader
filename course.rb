require 'mysql2'
require 'sequel'
require 'dotenv/load'
require_relative './lecture.rb'

class Course
  attr_accessor :id, :title, :lectures

  def initialize(id)
    @id = id
    @database ||= Sequel.connect(adapter: :mysql2, host: ENV['MYSQL_HOST'], user: ENV['MYSQL_USERNAME'], password: ENV['MYSQL_PASSWORD'], database: ENV['MYSQL_DATABASE_NAME'])
  end

  def get_course_info
    course_info = @database[:courses].first(id: id)
    @title = course_info[:title]
    @lectures = []

    @database[:lectures].where(course_id: id, type: 'VideoLecture').each do |lecture|
      @lectures.push(Lecture.new(id: lecture[:id], title: lecture[:title], position: lecture[:position], vimeo_video_id: lecture[:vimeo_video_id]))
    end
  end
end
