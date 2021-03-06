When /^I attach the file "([^"]*)" to "([^"]*)" on S3$/ do |file_path, field|
  definition = Paperclip::AttachmentRegistry.definitions_for(User)[field.downcase.to_sym]
  path = "https://paperclip.s3.us-west-2.amazonaws.com#{definition[:path]}"
  path.gsub!(':filename', File.basename(file_path))
  path.gsub!(/:([^\/\.]+)/) do |match|
    "([^\/\.]+)"
  end
  FakeWeb.register_uri(:pu                                                                                                                                                                                                                        