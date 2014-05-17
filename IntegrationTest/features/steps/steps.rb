SANDBOX_URL = 'https://sandbox.evernote.com/pub/olareoun/mipublicnotebook'
ARRANGE_SANDBOX_URL = 'https://sandbox.evernote.com/pub/olareoun/arrangenotebook'
EVERNOTE_URL = 'https://www.evernote.com/pub/wilthor/wilthorsnotebook'
JUST_TITLE = 'https://sandbox.evernote.com/pub/olareoun/just-title'
IMAGE_URL = 'https://sandbox.evernote.com/pub/olareoun/image'
IMAGES_URL = 'https://sandbox.evernote.com/pub/olareoun/images'
GIF_IMAGE_URL = 'https://sandbox.evernote.com/pub/olareoun/gif-image'
PNG_IMAGE_URL = 'https://sandbox.evernote.com/pub/olareoun/png-image'
AUDIO_URL = 'https://sandbox.evernote.com/pub/olareoun/audio'
AUDIOS_URL = 'https://sandbox.evernote.com/pub/olareoun/audios'

NOTEBOOKS = {
  'non existing evernote public notebook' => 'https://sandbox.evernote.com/pub/olareoun/non-existing',
  'notebook with a note and a link' => 'https://sandbox.evernote.com/pub/olareoun/link',
  'non evernote public notebook' => 'wwww.notevernotedomain.com/pub/xaviuzz/tal',
  'empty url' => '',
  'evernote public notebook' => ARRANGE_SANDBOX_URL,
  'evernote notebook' => EVERNOTE_URL,
  'sandbox notebook' => SANDBOX_URL,
  'notebook with a note and several audio files' => AUDIOS_URL,
  'notebook with a note and a audio' => AUDIO_URL,
  'notebook with a note and a png image' => PNG_IMAGE_URL,
  'notebook with a note and a gif image' => GIF_IMAGE_URL,
  'notebook with a note and several images' => IMAGES_URL,
  'notebook with a note and a image' => IMAGE_URL,
  'notebook with a note with just title' => JUST_TITLE
}

Given /^I am in notes2reveal$/ do
  visit 'http://localhost:3000/'
end

Given(/^I am in the arrange page$/) do
  step "I go to arrange"
end

Given(/^I change the order of the slides$/) do
  page.execute_script('$("#sortable li").sort(function(a, b){return ($(b).text()) > ($(a).text());}).appendTo("#sortable")')
  page.execute_script('$("#sortable").trigger("sortupdate")')
  page.evaluate_script("$('#sortable').sortable('toArray').toString()").empty?.should be_false
end

When(/^I look for an alert$/) do
end

When(/^I look for a field to insert a public evernote url$/) do
end

When(/^I try to create a presentation from a (.*)$/) do |notebook|
  step "I arrange a presentation from a #{notebook}"
end

When(/^I create a presentation from a (.*)$/) do |notebook|
  step "I arrange a presentation from a #{notebook}"
  step "I generate the presentation"
end

When(/^I arrange a presentation from a (.*)$/) do |notebook|
  step "I insert the #{notebook} url"
  step "I go to arrange"
end

When(/^I insert the (.*?) url$/) do |arg1|
  fill_in('publicUrl', :with => NOTEBOOKS[arg1])
end

When "I go to arrange" do
  find('#submit').click
end

When "I generate the presentation" do
  find('#generate').click
end

When(/^I send it to generate$/) do
  find('#generate').click
end

Then "I click down button" do
  page.find('div.navigate-down.enabled').click
  sleep 1
end

Then "I click right button" do
  page.find('div.navigate-right.enabled').click
  sleep 1
end

Then "presentation has been created" do
  page.has_css?("div.reveal").should be_true
  page.has_css?("div.slides").should be_true
end

Then(/^I should get a presentation with (\d+) horizontal slides$/) do |arg1|
  step "presentation has been created"
  page.all("div.slides section.n2e-slide-horizontal", :visible => false).length.should == 2
end

Then(/^I get back to the form$/) do
  step "I can see it"
end

Then(/^I see an alert message "(.*?)"$/) do |alert_message|
  page.has_css?("div.alert").should be_true
  page.find("div.alert").should have_content(alert_message)
end

Then(/^I can not see any alert$/) do
  page.has_css?("div.alert").should be_false
end

Then(/^I can see it$/) do
  page.find('#publicUrl').should be_true
end

Then(/^first title matches first note title$/) do
  step "presentation has been created"
  page.first("div.slides section .n2e-slide-title").text.should == 'segunda nota del publico'.upcase
end

Then(/^second title matches second note title$/) do
  step "I click right button"
  page.first("div.slides section .n2e-slide-title").text.should == 'primera nota del publico'.upcase
end

Then(/^first title matches first note title in evernote$/) do
  step "presentation has been created"
  page.first("div.slides section .n2e-slide-title").text.should == 'nota solo texto'.upcase
end

Then(/^second title matches second note title in evernote$/) do
  step "I click right button"
  page.first("div.slides section .n2e-slide-title").text.should == 'nana'.upcase
end

Then(/^third title matches third note title in evernote$/) do
  step "I click right button"
  page.first("div.slides section .n2e-slide-title").text.should == 'otra nota'.upcase
end

Then(/^I can see a list with the titles of my notes$/) do
  page.has_css?("ul").should be_true
  page.all("ul li").length.should == 4
  page.find('ul').text.should include('nota1', 'nota2', 'nota3', 'nota4') 
end

Then(/^I can see a sortable list with the titles of my notes$/) do
  page.has_css?("ul#sortable").should be_true
  page.all("ul li").length.should == 4
  page.find('ul').text.should include('nota1', 'nota2', 'nota3', 'nota4') 
  page.evaluate_script("$('#sortable').sortable('toArray').toString()").empty?.should be_false
end

Then(/^I have a button to generate presentation$/) do
  page.find('button#generate').should be_true
end

Then(/^the slides are generated in that order$/) do
  step "presentation has been created"
  page.all("div.slides .n2e-slide-title", :visible => false).length.should == 4
  page.first("div.slides section .n2e-slide-title").text.should == 'nota4'.upcase
  step "I click right button"
  page.first("div.slides section .n2e-slide-title").text.should == 'nota3'.upcase
  step "I click right button"
  page.first("div.slides section .n2e-slide-title").text.should == 'nota2'.upcase
  step "I click right button"
  page.first("div.slides section .n2e-slide-title").text.should == 'nota1'.upcase
end

Then(/^I should see the content of the note$/) do
  page.first("div.slides .n2e-slide-content").text.should == 'contenido de la segunda nota del publico'
end

Then(/^no vertical slide for content is generated$/) do
  step "presentation has been created"
  page.all("div.slides .n2e-slide-content", :visible => false).length.should == 0
end

Then(/^I can see the image in the third vertical position$/) do
  step "presentation has been created"
  step "I click down button"
  page.all("div.slides section img").length.should == 1
end

Then(/^I can see consecutive vertical slides$/) do
  step "presentation has been created"
  step "I click down button"
  page.all("div.slides section img").length.should == 1
  step "I click down button"
  page.all("div.slides section img").length.should == 1
end

Then(/^I can see the audio in the third vertical position$/) do
  step "presentation has been created"
  step "I click down button"
  page.all("div.slides section audio").length.should == 1
end

Then(/^I can see the audios in consecutive vertical slides$/) do
  step "presentation has been created"
  step "I click down button"
  page.all("div.slides section audio").length.should == 1
  step "I click down button"
  page.all("div.slides section audio").length.should == 1
end

Then(/^I can see the link in the content slide$/) do
  step "presentation has been created"
  step "I click down button"
  page.all("div.slides .n2e-slide-content a").length.should == 1
end