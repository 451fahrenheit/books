require 'rails_helper'

RSpec.describe Book, type: :model do

  it "thows error when volumeId is nil" do
    book=Book.new
    book.volumeId=""
    book.title="Book1"
    book.subtitle="Hello"
    book.description="Description of the book"
    book.authors="a1, a2"
    book.language="en"
    book.pubDate="12-12-1964"
    book.smallthumbnail="url1"
    book.thumbnail="url2"
    expect(book).not_to be_valid

  end
  it "serializes the authors list csv of strings" do

    book=Book.new
    authors=['Kartik', 'Jaymin']

    serialized_authors = book.serialize_authors(authors)

    expect(serialized_authors).to eq("Kartik,Jaymin")

  end
  it "deserializes the authors csv to array of strings" do

    book=Book.new
    authors="Kartik,Jaymin"

    deserialized_authors = book.deserialize_authors(authors)

    expect(deserialized_authors.count).to eq(2)
    expect(deserialized_authors[0]).to eq("Kartik")
    expect(deserialized_authors[1]).to eq("Jaymin")

  end
  
end
