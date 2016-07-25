class ArticleLog < ActiveRecord::Base; end
class UserHistory < ActiveRecord::Base; end

class Article < ActiveRecord::Base
  has_logs
end

class ArticleLog < ActiveRecord::Base
  act_as_log
end

class User < ActiveRecord::Base
  has_logs_as 'UserHistory', dependent: :destroy
end

class UserHistory < ActiveRecord::Base
  act_as_log_of 'User', dependent: :destroy
end
