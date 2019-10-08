class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]


        validates :name, presence: true
        has_many :plan
        has_many :sns_credentials, dependent: :destroy

        def self.find_oauth(auth)
          uid = auth.uid
          provider = auth.provider
          snscredential = SnsCredential.where(uid: uid, provider: provider).first
          if snscredential.present?
            user = User.where(id: snscredential.user_id).first
          else
            user = User.where(email: auth.info.email).first
            if user.present?
              SnsCredential.create(
                uid: uid,
                provider: provider,
                user_id: user.id
                )
            else
              user = User.create(
                name: auth.info.name,
                email:    auth.info.email,
                password: Devise.friendly_token[0, 20],
                uid: uid,
                provider: provider
                )
              SnsCredential.create(
                uid: uid,
                provider: provider,
                user_id: user.id
                )
            end
          end
          return user
        end
end
