User.create!(email: 'admin',
             password_digest: User.digest('password'),
             role: 'admin')
User.create!(email: 'needyou@tryingtowork.com',
             password_digest: User.digest('trucksRcool'),
             role: 'user')
User.create!(email: 'struggling@helpme.net',
             password_digest: User.digest('cats'),
             role: 'user')
User.create!(email: 'sally@needssupport.com',
             password_digest: User.digest('steel'),
             role: 'user')

SupportTicket.create(subject: 'Cannot log into email!!!!',
                     body: 'It says password is invalid, not sure what that means....', user_id: 2)
SupportTicket.create(subject: 'blank black screen?',
                     body: 'My laptop wont turn on... I spilled water on it last week but its been a week so that cant be it...', user_id: 2)
SupportTicket.create(subject: 'HELP!!!!',
                     body: 'My mom sent me this link on facebook... said i won.. is this safe?', user_id: 2)
SupportTicket.create(subject: 'My dog chewed the cord...',
                     body: 'Hi! my dog chewed up my cord... can you send me a new one?', user_id: 3)
SupportTicket.create(subject: 'Testing the waters...',
                     body: 'This is a test of a new ticketing system!', user_id: 3)
