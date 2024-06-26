require_dependency 'mailer'

module RedmineMailFrom
  module MailerModelPatch

    def mail(headers={}, &block)

      placeholder = {
        '%f' => @author ? @author.firstname : nil,
        '%l' => @author ? @author.lastname : nil,
        '%m' => (@author && @author.mail && !@author.pref.hide_mail) ?
        @author.mail : nil,
        '%u' => @author ? @author.login : nil,
        '%p' => @issue ? @issue.project.name : nil
      }

      from = ''

      Setting.mail_from.split(/\s*::\s*/).each do |s|
        nerr = 0

        placeholder.each do |key, val|
          next unless s.match(/#{key}/)

          if val.nil? then nerr += 1 end

          s.gsub!(/#{key}/, val || '')
        end

        from = s

        break if nerr == 0
      end

      host = Setting.host_name.split(/[\/:]/).first

      if @issue
        listid = "<#{@issue.project.identifier}.#{host}>"
        to = headers[:to]
        if to.is_a? User
          u = headers[:to]
        else
          u = headers[:to][0]
        end
        if u.mail.split("@").last.upcase != from.split("@").last.upcase
          headers[:subject] = "[#{@issue.project.name} - #{@issue.tracker.name} ##{@issue.id}] "
        end
      else
        listid = "<#{host}>"
      end

      headers['From'] = from
      headers['List-Id'] = listid

      super(headers, &block)
    end
  end
end
