require 'digest'

module Utils
  def content_md5(file_path)
    File.open(file_path, 'rb') do |file|
      md5 = Digest::MD5.new
      md5 << file.read
      md5.hexdigest
    end
  end

  def file_content_change?(file1, file2)
    if !File.exist?(file1) || !File.exist?(file2)
      return true
    end
    hash1 = content_md5(file1)
    hash2 = content_md5(file2)
    return !(hash1 == hash2)
  end

  def osname
    case RUBY_PLATFORM.downcase
    when /darwin/
     "darwin"
    when /linux/
     "linux"
    when /mswin|win32|mingw|cygwin/
     "win"
    else
      nil
    end
  end
end
