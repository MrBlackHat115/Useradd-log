# **What is Useradd-log?**

* Useradd-log is a Bash wrapper script for the Linux useradd command that logs all user creations and notifies the system administrator in real-time. It enhances auditing and accountability in multi-admin environments.

# **Features**

*Logs every successful user creation to /var/log/user_creation.log with:

* Username created

* Admin who created it

* Timestamp

*Sends real-time notifications via wall

*Optional email alerts if mail is configured

*Safe wrapper: calls the real useradd binary without altering system behavior

*Configurable admin username or email
