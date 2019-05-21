# 2019-05-21 - Write a Ruby script to download Videos from Vimeo and Create Folder by Course (on ShareWis)

# Input Course Id
# Get Course Info (Title & Lectures, Vimeo Video Ids from ShareWis)
# Create Folder by Course Title
# For each Lecture
# Download Video File (If available), and name it by lecture name
require 'dotenv/load'
require 'rest-client'
require 'json'

class VimeoService
  attr_reader :vimeo_video_id

  def initialize(vimeo_video_id)
    @vimeo_video_id = vimeo_video_id
  end

  def get_video_info
    get_api("#{base_site}/videos/#{vimeo_video_id}")
  end

  private

  def headers
    { Authorization: "Bearer #{ENV['VIMEO_ACCESS_TOKEN']}" }
  end

  def base_site
    'https://api.vimeo.com'
  end

  def get_api(uri)
    r = RestClient.get(uri, headers)
    JSON.parse(r.body)
  end
end
