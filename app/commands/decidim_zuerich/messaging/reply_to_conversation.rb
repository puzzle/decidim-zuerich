# frozen_string_literal: true

# Override last checked at: 22.07.2026
module DecidimZuerich
  module Messaging
    module ReplyToConversation
      def notify(recipient)
        # Only removing this first condition, see #620
        #return unless conversation.unread_count(recipient) == 1
        return unless recipient.accepts_conversation?(form.context.current_user)

        yield unless @already_notified.include?(recipient)
        @already_notified.push(recipient)
      end
    end
  end
end
