require 'rails_helper'

RSpec.describe Post, type: :model do 
  let!(:post) { create(:post) }

  it "is valid with valid attributes" do
    post = Post.new
    post.title="beta@incubyte.co"
    post.subtitle="beta@incubyte.co"
    post.content="beta@incubyte.co"
    post.excerpt="beta@incubyte.co"

    expect(post).to be_valid
  end

  it "is invalid without email" do
    post = Post.new
    expect(post).not_to be_valid
  end
  
  it "is invalid without content" do
    post = Post.new
    post.title="alpha"
    post.content=""
    expect(post).not_to be_valid
  end
end
