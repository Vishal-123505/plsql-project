# Hospital Bed Management System

# CREATED BY : NAWALE VISHAL SHANTARAM

# COLLEGE NAME : AMRUTVAHINI COLLGE OF ENGINEERING

## DESCRIPTION :
    The Hospital Bed Management System is designed to manage hospital rooms, beds, patients, staff, medical records, and bed      allocation history. The system provides an efficient way to manage the daily operations of a hospital by ensuring             accurate tracking of bed availability, patient assignments, and staff management.

## FEATURES :  
Room Management: Manage hospital rooms, their types, and capacity.
Bed Assignment: Assign patients to available beds and track bed status.
Patient Management: Manage patient details such as admission date and assigned bed.
Staff Management: Store and manage staff details like name, position, and department.
Medical Records: Store and update medical records for each patient.
Bed History Tracking: Track the history of patient bed assignments.


## TABLES : 
rooms: Stores information about hospital rooms.

room_id: Unique identifier for each room.
room_type: Type of the room (e.g., private, shared).
capacity: Capacity of the room.
beds: Stores information about individual beds.

bed_id: Unique identifier for each bed.
room_id: Foreign key linking to the room.
bed_status: Status of the bed (e.g., vacant, occupied).
departments: Stores information about hospital departments.

department_id: Unique identifier for each department.
department_name: Name of the department.
head_of_department: Head of the department.
staff: Stores information about hospital staff.

staff_id: Unique identifier for each staff member.
name: Name of the staff member.
position: Position held by the staff member.
department_id: Foreign key linking to the department.
patients: Stores information about hospital patients.

patient_id: Unique identifier for each patient.
name: Name of the patient.
admission_date: Date when the patient was admitted.
assigned_bed: Foreign key linking to the assigned bed.
department_id: Foreign key linking to the department.
medical_records: Stores medical records for patients.

record_id: Unique identifier for each medical record.
patient_id: Foreign key linking to the patient.
record_date: Date of the medical record.
diagnosis: Diagnosis provided for the patient.
treatment: Treatment prescribed for the patient.
doctor_id: Foreign key linking to the doctor/staff member responsible.
bed_history: Tracks the history of bed assignments.

history_id: Unique identifier for each bed assignment history.
patient_id: Foreign key linking to the patient.
bed_id: Foreign key linking to the bed.
start_date: Date when the patient was assigned to the bed.


# GUIDANCE BY : ANIRUDDHA GAIKWAD
