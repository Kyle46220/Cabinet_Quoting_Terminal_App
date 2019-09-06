
chmod +x ./build.sh
mkdir dist
cp ./app.rb ./dist
cp ./contacts.rb ./dist
cp ./test.rb ./dist

gem install Rubocop
gem install colorize 
gem install tty-prompt
 