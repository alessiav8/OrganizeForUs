class SubValidator < ActiveModel::Validator
        def validate(record)
          if User.find_by(:email, record.user_email)!=nil
            record.update(iscritto: true)
          end
        end
      end
