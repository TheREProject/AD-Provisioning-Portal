
**Disclaimer**
==================
This project is a simulated Active Directory provisioning environment created for educational and portfolio demonstration purposes.

All organizational data, domains, and identities used within this project are fictional and do not represent any real individuals, groups, or organizations.


**Overview**
==================
AD Provisioning Portal is a web-based Active Directory onboarding and provisioning platform designed to automate common identity and access management workflows.

The project integrates a dynamic HTML/JavaScript frontend with PowerShell automation scripts to streamline user provisioning, security group management, and organizational unit (OU) placement within Active Directory environments.

The platform dynamically retrieves organizational structure and security group information from Active Directory through JSON exports, reducing manual entry and improving provisioning consistency.

**Scope and Results**
==================
At least two hours of manual creation compressed to 10 minutes. Consisting of,
- The creation of 65+ users
- 22 OUs
- 70+ security groups

  
**Getting Started**
==================
## Prerequisites
- Windows Server with the Active Directory role installed.
- PowerShell 5.1 or greater
- A PowerShell Editior (Visual Studio Code is a good choice)
- A .csv reader (e.g Excel)
- An HTML Editor (Notepad is technically usable, but Sublime Text is far superior)

### Optional
- Proxmox Hypervisor (If you want to virtualize your Windows Server)

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
- Custom 404 and homepage UI


Procedure
==================

1. Run the "OUCreation" and "SecurityGroupCreation" scripts. This will create Active Directory's Top-Level Company OUs and their baseline department neested OUs.
2. **Optional**: You may create company exclusive OUs and Security Groups.
3. Run the company specific "OU Data to JSON" Script to grab the company's Department OUs and Security Groups.
4. Add the JSON to the company's web portal folder so that it can be read by the site. 
7. With the JSON loaded in the web form, you are free to input user data for .csv exports. If you forget to generate a password, one will be created for you. 
8. With this exported .csv data, you can run the company's user creation script. This script will add all imported users into the company's selected OU and assign them to their selected security group.


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
##**JSON Export Log**



## **[Homepage]**

Central page for selecting organization-specific provisioning tool.<br>
**Link:**  https://thereproject.github.io/AD-Provisioning-Portal/
<img width="1920" height="947" alt="image" src="https://github.com/user-attachments/assets/49356de3-1a2e-4f48-8037-4fc4d05a188f" /><br>




## **[User Provisioning Form with dynamic Active Directory data loading]**

Security Groups and Departments loaded from JSON file exported from Active Directory via Powershell.
<img width="1880" height="931" alt="image" src="https://github.com/user-attachments/assets/3ccebdab-8dcf-4694-bd7f-8ecae58ce3d0" /><br>




## **[User data overview]**
<img width="1296" height="717" alt="image" src="https://github.com/user-attachments/assets/dfe63f20-41c9-459c-b034-62f7b7b02e6f" />
<br>




## **[CSV Exports]**
### Example 1
<img width="1597" height="153" alt="image" src="https://github.com/user-attachments/assets/163d4de7-bd36-47b1-bdfa-fd1bc7a565d5" />
<br>

### Example 2
<img width="1613" height="810" alt="image" src="https://github.com/user-attachments/assets/46bdd4f6-1c84-4095-a251-08d4c28ba523" />
<br>




## **[Logging Output]**
### Example 1
<img width="2892" height="1841" alt="image" src="https://github.com/user-attachments/assets/c9ce5039-b26d-4169-bf64-9f1c50cdb196" />
<br>

### Example 2
<img width="2887" height="1835" alt="image" src="https://github.com/user-attachments/assets/cfcbfd6a-7f23-4f2e-9093-f7a0a4393012" />
<br>



## **[Active Directory Output]**
### Example 1
<img width="2880" height="2047" alt="image" src="https://github.com/user-attachments/assets/aeb11e2e-bc08-483b-9697-581f0c466440" />
<br>

### Example 2
<img width="3209" height="2056" alt="image" src="https://github.com/user-attachments/assets/899858b6-aa65-4dde-acd5-f80356dcde2e" />


**What this project demonstrates**
====================================

This project demonstrates end-to-end automation of identity provisioning workflows using Active Directory, PowerShell scripting, 
and a web-based interface, with a focus on reducing manual administrative effort and improving consistency in user onboarding processes.


**Future Improvements**
=========================
- JSON upload feature
- SSO integration
- Authentication
- APIs
- Mailbox Provisioning
