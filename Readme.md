
**Disclaimer**
==================
This project is a simulated Active Directory provisioning environment created for educational and portfolio demonstration purposes.

All organizational data, domains, and identities used within this project are fictional and do not represent any real individuals, groups, or organizations.


**Overview**
==================
AD Provisioning Portal is a web-based Active Directory onboarding and provisioning platform designed to automate common identity and access management workflows.

The project integrates a dynamic HTML/JavaScript frontend with PowerShell automation scripts to streamline user provisioning, security group management, and organizational unit (OU) placement within Active Directory environments.

The platform dynamically retrieves organizational structure and security group information from Active Directory through JSON exports, reducing manual entry and improving provisioning consistency.

This project was designed as a scalable multi-organization provisioning environment with future expansion planned for authentication, SSO integration, role-based access control, and API-driven provisioning workflows.


**Features**
==================

- Dynamic Active Directory OU discovery
- Automated security group enumeration
- Web-based user provisioning interface
- JSON-driven frontend population
- Automated user creation via PowerShell
- Automated security group assignment
- Organization-specific provisioning workflows
- Recursive OU and group discovery
- Centralized logging and error handling
- Scheduled AD data export support
- Scalable multi-organization architecture
- Custom 404 and homepage UI


**Architecture**
==================

Active Directory → PowerShell Export Scripts → JSON Data → Web Frontend → Provisioning CSV/Input → PowerShell Automation → Active Directory


**Technologies Used**
=======================
- PowerShell
- Active Directory
- HTML5
- CSS3
- JavaScript
- JSON
- Windows Task Scheduler
- GitHub Pages


**Screenshots**
==================
## **[Homepage]**

Central page for selecting organization specific provisioning tool.

<img width="1920" height="947" alt="image" src="https://github.com/user-attachments/assets/49356de3-1a2e-4f48-8037-4fc4d05a188f" /><br>




## **[User Provisioning Form with dynamic Active Directory data loading]**

Security Groups and Departments loaded from JSON file exported from Active Directory via Powershell.
<img width="1880" height="931" alt="image" src="https://github.com/user-attachments/assets/3ccebdab-8dcf-4694-bd7f-8ecae58ce3d0" /><br>




## **[User data overview]**
<img width="1296" height="717" alt="image" src="https://github.com/user-attachments/assets/dfe63f20-41c9-459c-b034-62f7b7b02e6f" />
<br>




## **[CSV Export]**
<img width="1597" height="153" alt="image" src="https://github.com/user-attachments/assets/163d4de7-bd36-47b1-bdfa-fd1bc7a565d5" />
<br>




## **[Logging Output]**
<img width="2892" height="1841" alt="image" src="https://github.com/user-attachments/assets/c9ce5039-b26d-4169-bf64-9f1c50cdb196" /><br>




## **[Active Directory Output]**
<img width="2880" height="2047" alt="image" src="https://github.com/user-attachments/assets/aeb11e2e-bc08-483b-9697-581f0c466440" /><br>


**What this project demonstrates**
====================================

This project demonstrates end-to-end automation of identity provisioning workflows using Active Directory, PowerShell Scripting, 
and a web-based interface, with a focus on reducing manual administrative effot and improving consistency in user onboarding processes.


**Future Improvments**
=========================
- SSO integration
- Authentication
- APIs
- Mailbox Provisioning
