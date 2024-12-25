# JQ is used for JSON parsing and building

if ! [ -x "$(command -v jq)" ]; then
  echo "JQ is not installed. Installing JQ..."
  if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get install jq
  elif [ -x "$(command -v yum)" ]; then
    sudo yum install jq
  elif [ -x "$(command -v brew)" ]; then
    brew install jq
  else
    echo "Error: Could not install JQ. Please install JQ manually."
    exit 1
  fi
fi