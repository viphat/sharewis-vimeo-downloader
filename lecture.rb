class Lecture
  attr_accessor :id, :title, :position, :vimeo_video_id

  def initialize(id:, title:, position:, vimeo_video_id:)
    @id = id
    @title = title
    @position = position
    @vimeo_video_id = vimeo_video_id
  end

  def video_file_name
    "#{position.nil? ? '' : position} #{title}".strip
  end
end
