#!/bin/bash

# MIT License
# 
# Copyright (c) 2024 Fred Fisher, Validus Group Inc. (www.validusgroup.com)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Function to print a message with formatting
echo_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

echo_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

# Check if SSH keys already exist
check_ssh_keys() {
    echo_info "Checking for existing SSH keys..."
    if [ -f "$HOME/.ssh/id_ed25519" ] || [ -f "$HOME/.ssh/id_rsa" ]; then
        echo_info "Existing SSH keys found."
        return 0
    else
        echo_info "No existing SSH keys found."
        return 1
    fi
}

# Generate a new SSH key
generate_ssh_key() {
    local email=$1

    echo_info "Generating a new SSH key..."
    if command -v ssh-keygen >/dev/null 2>&1; then
        ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""
        echo_info "SSH key generated at $HOME/.ssh/id_ed25519."
    else
        echo_error "ssh-keygen not found. Please install OpenSSH tools and try again."
        exit 1
    fi
}

# Start the SSH agent and add the key
add_ssh_key_to_agent() {
    echo_info "Starting the SSH agent and adding the key..."
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_ed25519"
    echo_info "SSH key added to the agent."
}

# Copy the SSH key to the clipboard or display it
show_ssh_key() {
    echo_info "Public SSH key (add this to GitHub):"
    cat "$HOME/.ssh/id_ed25519.pub"
    echo_info "You can copy the above key manually or use a clipboard manager."
}

# Main script
main() {
    echo "Welcome to the GitHub SSH setup script!"

    # Prompt for the user's email
    read -p "Enter your GitHub email address: " email

    # Check if SSH keys exist
    if check_ssh_keys; then
        echo_info "Using the existing SSH keys."
    else
        # Generate new SSH key
        generate_ssh_key "$email"
    fi

    # Add the key to the SSH agent
    add_ssh_key_to_agent

    # Show the public key
    show_ssh_key

    echo_info "To complete the setup, go to GitHub -> Settings -> SSH and GPG keys, and add the above key."
    echo_info "Test your connection with: ssh -T git@github.com"
}

# Execute the main function
main
