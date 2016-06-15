require 'rails_helper'

RSpec.feature "Search and display an user", :vcr do
  background { visit root_path }

  scenario 'should find the GitHub user' do
    fill_in 'username', with: 'arnlen'
    click_button 'Search'

    expect(page).to have_content 'arnlen'
  end
end
