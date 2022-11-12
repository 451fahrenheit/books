module Mutations
	class LoginUser < BaseMutation
		# null true
		argument :credentials, Types::AuthProviderCredentialsInput, required: true
		
		field :user, Types::UserType, null: true
		field :token, String, null: true

		def resolve(credentials: nil)

			user = User.find_by email: credentials[:email]
			
			unless user
				return GraphQL::ExecutionError.new("Account not found, create an account or check for spelling in existing")
			end

			unless user.authenticate(credentials[:password])
				return GraphQL::ExecutionError.new('Incorrect password, check if capslock is on')
			end
			
			crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base.byteslice(0..31))
			token = crypt.encrypt_and_sign("user-id:#{ user.id }")
			# context[:session][:token] = token

			{ user: user, token: token }
			
		end
	end
end