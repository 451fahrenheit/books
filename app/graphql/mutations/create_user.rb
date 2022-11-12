module Mutations
    class CreateUser < BaseMutation
        class AuthProviderSignupData < Types::BaseInputObject
            argument :credentials, Types::AuthProviderCredentialsInput, required: false
        end
        argument :auth_provider, AuthProviderSignupData, required: false

        field :user, Types::UserType, null: true

        def resolve(auth_provider: nil)
            user = User.find_by email: auth_provider&.[](:credentials)&.[](:email)
            unless(user)
                user = User.create!(
                    email: auth_provider&.[](:credentials)&.[](:email),
                    password: auth_provider&.[](:credentials)&.[](:password)
                 )
                {user: user}
                
            else
                GraphQL::ExecutionError.new('Account already exists with this email.')
            end
        end
    end
end