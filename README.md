# User Management Script

## Description

`create_users.sh` is a bash script that automates the process of creating users and groups based on an input file. It sets up home directories, generates random passwords, and logs all actions performed during the execution.

## Features

- Creates users and their personal groups.
- Adds users to specified additional groups.
- Generates random passwords for new users.
- Sets appropriate permissions for home directories.
- Logs all actions to a log file.
- Outputs generated passwords to a secure file.

## Requirements

- The script must be run as root.
- The input file should be in the format: `username;group1,group2,...`.

## Usage

1. Clone the repository:
    ```sh
    git clone (https://github.com/IsmailMuhammed2019/Linux-User-Creation-Bash-Script)
    cd Linux-User-Creation-Bash-Script
    ```

2. Make the script executable:
    ```sh
    chmod +x create_users.sh
    ```

3. Run the script with the input file:
    ```sh
    sudo ./create_users.sh <input-file>
    ```

    - `<input-file>`: Path to the file containing user and group information.

## Input File Format

The input file should contain user and group information in the following format:
```
username;group1,group2,...
```
Each line represents a single user. Groups are optional and should be separated by commas.

Example:
```
alice;admin,developers
bob;users
charlie;
```

## Logs

- Actions performed by the script are logged in `/var/log/user_management.log`.
- Generated passwords are saved in `/var/secure/user_passwords.csv` with restricted permissions.

## Example

Here is an example of how to use the script:

1. Create an input file `users.txt` with the following content:
    ```
    alice;admin,developers
    bob;users
    charlie;
    ```

2. Run the script:
    ```sh
    sudo ./create_users.sh users.txt
    ```

3. Check the log file for details:
    ```sh
    cat /var/log/user_management.log
    ```

4. Check the generated passwords:
    ```sh
    sudo cat /var/secure/user_passwords.csv
    ```

## Notes

- Ensure that the script is executed with root privileges.
- Verify the format of the input file before running the script.
- The script will create necessary groups if they do not already exist.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to contribute to this project by opening issues or submitting pull requests.

## Author

- [Your Name](https://github.com/your-github-username)

```
