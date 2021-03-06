# senior-project
Senior project repository containing the code files to run the COVID Health Monitoring Application.

COVID Health Monitoring Application (Android Version), version v1.0, 13.07.2021
===================================================================================

* This version of the titled application is designed to run on Android mobile devices. The most recent Android version that the application was tested on was Android 11.

* The application requires a stable and preferably fast Internet (Cellular or Wi-Fi) connection, as it connects to cloud database, as well as to an online host that contains the SQL database.

* The application requires access to the location information to function as expected. Unless this is turned on by the user, the application is not guaranteed to work. We recommend location services to be constantly turned on throughout the usage of the application. Turning the location service off and on again may also cause inaccuracies is GPS-based features provided in the application, such as quarantine status of the patients. It is important to not to use another application that manipulates the location service.

* The application provides features to make a call or send an e-mail, therefore, it is recommended to have an active SIM card, as well as an e-mail client. This is only recommended for the healthcare personnels, as they may want to contact with the patients that are ought to stay in quarantine, yet violating it.

* The application requires an e-mail address and a password as credentials to sign up, and to log in.

* Patients are recommended to fill-in their profile information for the application to conduct the required data analysis. Similarly, doctors are recommended to fill-in the test results of the patients whenever they can.

* Administrator is the only role that can asssess the efficiency of the executed queries that are supposed to be compared based on the execution times. This is significant as the essential goal of the application is to compare two database models, namely SQL and NoSQL (Firebase).