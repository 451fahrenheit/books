module Mutations
    class CreateUser < BaseMutation
        class AuthProviderSignupData < Types::BaseInputObject
            argument :credentials, Types::AuthProviderCredentialsInput, required: false
        end
        argument :auth_provider, AuthProviderSignupData, required: false

        field :success, Boolean, null: true
        field :user, Types::UserType, null: true

        def resolve(auth_provider: nil)
            user = User.find_by email: auth_provider&.[](:credentials)&.[](:email)
            if(user)
                {success:false}
            else
                user = User.new(
                    email: auth_provider&.[](:credentials)&.[](:email),
                    password: auth_provider&.[](:credentials)&.[](:password)
                 )
                user.save
                {user: user, success: true}
             
            end

        end
    end
end