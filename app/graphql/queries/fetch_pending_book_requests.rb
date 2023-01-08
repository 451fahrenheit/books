module Queries
  class FetchPendingBookRequests < Queries::BaseQuery

    type [Types::PendingBookRequestType], null: false

    def resolve
      user = context[:current_user]

      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end

      pendingRequests = []
      users = User.find(user.id)
      book_requests = BookRequest.where(sent_to_id: user.id, status: false)
      
      unless book_requests.count>0
        return GraphQL::ExecutionError.new('Currently user does not have any requests')
      end

      book_requests.each do |request|
        book_id = request.sent_for_id
        book = Book.find(book_id)
        bookDTO={}
        bookDTO['id'] = book.id
        bookDTO['volumeId'] = book.volumeId
        bookDTO['title'] = book.title
        bookDTO['subtitle'] = book.subtitle
        bookDTO['description'] = book.description
        bookDTO['language'] = book.language
        bookDTO['pubDate'] = book.pubDate
        bookDTO['thumbnail'] = book.thumbnail
        bookDTO['smallthumbnail'] = book.smallthumbnail
        bookDTO['authors'] = Book.new.deserialize_authors(book.authors)

        requested_by_id = request.sent_by_id
        requested_by = User.find(requested_by_id)
        u = {}
        u["email"] = requested_by.email
        u["id"] = requested_by.id
        bookDTO["requestedBy"] = u
        pendingRequests << bookDTO
      end

      pendingRequests
    end
  end
end