
-- Create rooms table
CREATE TABLE rooms (
    room_id INT PRIMARY KEY,
    room_type VARCHAR2(50),
    capacity INT
);

-- Create beds table
CREATE TABLE beds (
    bed_id INT PRIMARY KEY,
    room_id INT,
    bed_status VARCHAR2(50) CHECK (bed_status IN ('vacant', 'occupied', 'reserved')),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR2(100),
    head_of_department INT,
    FOREIGN KEY (head_of_department) REFERENCES staff(staff_id)
);

-- Create staff table
CREATE TABLE staff (
    staff_id INT PRIMARY KEY,
    name VARCHAR2(100),
    position VARCHAR2(50),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create patients table
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR2(100),
    admission_date DATE,
    discharge_date DATE,
    assigned_bed INT,
    department_id INT,
    FOREIGN KEY (assigned_bed) REFERENCES beds(bed_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create medical records table
CREATE TABLE medical_records (
    record_id INT PRIMARY KEY,
    patient_id INT,
    record_date DATE,
    diagnosis VARCHAR2(255),
    treatment VARCHAR2(255),
    doctor_id INT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES staff(staff_id)
);

-- Create bed history table
CREATE TABLE bed_history (
    history_id INT PRIMARY KEY,
    patient_id INT,
    bed_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (bed_id) REFERENCES beds(bed_id)
);


-- Create sequence for patient_id
CREATE SEQUENCE patient_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create sequence for bed_id
CREATE SEQUENCE bed_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create sequence for staff_id
CREATE SEQUENCE staff_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create sequence for room_id
CREATE SEQUENCE room_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create sequence for department_id
CREATE SEQUENCE department_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create sequence for record_id
CREATE SEQUENCE record_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create sequence for history_id
CREATE SEQUENCE history_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


CREATE OR REPLACE PROCEDURE assign_bed_to_patient(
    p_name IN VARCHAR2,
    p_room_id IN INT,
    p_department_id IN INT
) IS
    v_patient_id INT := patient_seq.NEXTVAL;
    v_bed_id INT;
BEGIN
    -- Find an available bed in the room
    SELECT bed_id
    INTO v_bed_id
    FROM beds
    WHERE room_id = p_room_id AND bed_status = 'vacant'
    AND ROWNUM = 1;

    -- Update bed status to 'occupied'
    UPDATE beds
    SET bed_status = 'occupied'
    WHERE bed_id = v_bed_id;

    -- Insert new patient record
    INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id)
    VALUES (v_patient_id, p_name, SYSDATE, v_bed_id, p_department_id);

    -- Insert bed history record
    INSERT INTO bed_history (history_id, patient_id, bed_id, start_date)
    VALUES (history_seq.NEXTVAL, v_patient_id, v_bed_id, SYSDATE);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Patient ' || p_name || ' assigned to bed ' || v_bed_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No available beds in room ' || p_room_id);
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE discharge_patient(
    p_patient_id IN INT
) IS
    v_bed_id INT;
BEGIN
    -- Get the assigned bed ID
    SELECT assigned_bed
    INTO v_bed_id
    FROM patients
    WHERE patient_id = p_patient_id;

    -- Update bed status to 'vacant'
    UPDATE beds
    SET bed_status = 'vacant'
    WHERE bed_id = v_bed_id;

    -- Update patient's discharge date
    UPDATE patients
    SET discharge_date = SYSDATE
    WHERE patient_id = p_patient_id;

    -- Update bed history with the end date
    UPDATE bed_history
    SET end_date = SYSDATE
    WHERE patient_id = p_patient_id AND bed_id = v_bed_id AND end_date IS NULL;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Patient discharged and bed ' || v_bed_id || ' is now vacant.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Patient ID not found.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/



CREATE OR REPLACE PROCEDURE update_bed_status(
    p_bed_id IN INT,
    p_new_status IN VARCHAR2
) IS
BEGIN
    -- Update bed status
    UPDATE beds
    SET bed_status = p_new_status
    WHERE bed_id = p_bed_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Bed ' || p_bed_id || ' status updated to ' || p_new_status);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Bed ' || p_bed_id || ' not found.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- Insert values into rooms table
INSERT INTO rooms (room_id, room_type, capacity) VALUES (room_seq.NEXTVAL, 'Room Type 1', 10);
INSERT INTO rooms (room_id, room_type, capacity) VALUES (room_seq.NEXTVAL, 'Room Type 2', 11);
INSERT INTO rooms (room_id, room_type, capacity) VALUES (room_seq.NEXTVAL, 'Room Type 3', 12);
INSERT INTO rooms (room_id, room_type, capacity) VALUES (room_seq.NEXTVAL, 'Room Type 4', 13);
INSERT INTO rooms (room_id, room_type, capacity) VALUES (room_seq.NEXTVAL, 'Room Type 5', 14);
INSERT INTO rooms (room_id, room_type, capacity) VALUES (room_seq.NEXTVAL, 'Room Type 6', 15);
INSERT INTO rooms (room_id, room_type, capacity) VALUES (room_seq.NEXTVAL, 'Room Type 7', 16);
INSERT INTO rooms (room_id, room_type, capacity) VALUES (room_seq.NEXTVAL, 'Room Type 8', 17);
INSERT INTO rooms (room_id, room_type, capacity) VALUES (room_seq.NEXTVAL, 'Room Type 9', 18);
INSERT INTO rooms (room_id, room_type, capacity) VALUES (room_seq.NEXTVAL, 'Room Type 10', 19);




-- Insert values into beds table
INSERT INTO beds (bed_id, room_id, bed_status) VALUES (bed_seq.NEXTVAL, 1, 'vacant');
INSERT INTO beds (bed_id, room_id, bed_status) VALUES (bed_seq.NEXTVAL, 2, 'occupied');
INSERT INTO beds (bed_id, room_id, bed_status) VALUES (bed_seq.NEXTVAL, 3, 'vacant');
INSERT INTO beds (bed_id, room_id, bed_status) VALUES (bed_seq.NEXTVAL, 4, 'occupied');
INSERT INTO beds (bed_id, room_id, bed_status) VALUES (bed_seq.NEXTVAL, 5, 'vacant');
INSERT INTO beds (bed_id, room_id, bed_status) VALUES (bed_seq.NEXTVAL, 6, 'occupied');
INSERT INTO beds (bed_id, room_id, bed_status) VALUES (bed_seq.NEXTVAL, 7, 'vacant');
INSERT INTO beds (bed_id, room_id, bed_status) VALUES (bed_seq.NEXTVAL, 8, 'occupied');
INSERT INTO beds (bed_id, room_id, bed_status) VALUES (bed_seq.NEXTVAL, 9, 'vacant');
INSERT INTO beds (bed_id, room_id, bed_status) VALUES (bed_seq.NEXTVAL, 10, 'occupied');



-- Insert values into departments table
INSERT INTO departments (department_id, department_name, head_of_department) VALUES (department_seq.NEXTVAL, 'Department 1', NULL);
INSERT INTO departments (department_id, department_name, head_of_department) VALUES (department_seq.NEXTVAL, 'Department 2', NULL);
INSERT INTO departments (department_id, department_name, head_of_department) VALUES (department_seq.NEXTVAL, 'Department 3', NULL);
INSERT INTO departments (department_id, department_name, head_of_department) VALUES (department_seq.NEXTVAL, 'Department 4', NULL);
INSERT INTO departments (department_id, department_name, head_of_department) VALUES (department_seq.NEXTVAL, 'Department 5', NULL);
INSERT INTO departments (department_id, department_name, head_of_department) VALUES (department_seq.NEXTVAL, 'Department 6', NULL);
INSERT INTO departments (department_id, department_name, head_of_department) VALUES (department_seq.NEXTVAL, 'Department 7', NULL);
INSERT INTO departments (department_id, department_name, head_of_department) VALUES (department_seq.NEXTVAL, 'Department 8', NULL);
INSERT INTO departments (department_id, department_name, head_of_department) VALUES (department_seq.NEXTVAL, 'Department 9', NULL);
INSERT INTO departments (department_id, department_name, head_of_department) VALUES (department_seq.NEXTVAL, 'Department 10', NULL);



-- Insert values into staff table
INSERT INTO staff (staff_id, name, position, department_id) VALUES (staff_seq.NEXTVAL, 'Staff 1', 'Position 1', 1);
INSERT INTO staff (staff_id, name, position, department_id) VALUES (staff_seq.NEXTVAL, 'Staff 2', 'Position 2', 2);
INSERT INTO staff (staff_id, name, position, department_id) VALUES (staff_seq.NEXTVAL, 'Staff 3', 'Position 3', 3);
INSERT INTO staff (staff_id, name, position, department_id) VALUES (staff_seq.NEXTVAL, 'Staff 4', 'Position 4', 4);
INSERT INTO staff (staff_id, name, position, department_id) VALUES (staff_seq.NEXTVAL, 'Staff 5', 'Position 5', 5);
INSERT INTO staff (staff_id, name, position, department_id) VALUES (staff_seq.NEXTVAL, 'Staff 6', 'Position 6', 6);
INSERT INTO staff (staff_id, name, position, department_id) VALUES (staff_seq.NEXTVAL, 'Staff 7', 'Position 7', 7);
INSERT INTO staff (staff_id, name, position, department_id) VALUES (staff_seq.NEXTVAL, 'Staff 8', 'Position 8', 8);
INSERT INTO staff (staff_id, name, position, department_id) VALUES (staff_seq.NEXTVAL, 'Staff 9', 'Position 9', 9);
INSERT INTO staff (staff_id, name, position, department_id) VALUES (staff_seq.NEXTVAL, 'Staff 10', 'Position 10', 10);



-- Insert values into patients table
INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id) VALUES (patient_seq.NEXTVAL, 'Patient 1', SYSDATE, 1, 1);
INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id) VALUES (patient_seq.NEXTVAL, 'Patient 2', SYSDATE, 2, 2);
INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id) VALUES (patient_seq.NEXTVAL, 'Patient 3', SYSDATE, 3, 3);
INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id) VALUES (patient_seq.NEXTVAL, 'Patient 4', SYSDATE, 4, 4);
INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id) VALUES (patient_seq.NEXTVAL, 'Patient 5', SYSDATE, 5, 5);
INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id) VALUES (patient_seq.NEXTVAL, 'Patient 6', SYSDATE, 6, 6);
INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id) VALUES (patient_seq.NEXTVAL, 'Patient 7', SYSDATE, 7, 7);
INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id) VALUES (patient_seq.NEXTVAL, 'Patient 8', SYSDATE, 8, 8);
INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id) VALUES (patient_seq.NEXTVAL, 'Patient 9', SYSDATE, 9, 9);
INSERT INTO patients (patient_id, name, admission_date, assigned_bed, department_id) VALUES (patient_seq.NEXTVAL, 'Patient 10', SYSDATE, 10, 10);



-- Insert values into medical_records table
INSERT INTO medical_records (record_id, patient_id, record_date, diagnosis, treatment, doctor_id) VALUES (record_seq.NEXTVAL, 1, SYSDATE, 'Diagnosis 1', 'Treatment 1', 1);
INSERT INTO medical_records (record_id, patient_id, record_date, diagnosis, treatment, doctor_id) VALUES (record_seq.NEXTVAL, 2, SYSDATE, 'Diagnosis 2', 'Treatment 2', 2);
INSERT INTO medical_records (record_id, patient_id, record_date, diagnosis, treatment, doctor_id) VALUES (record_seq.NEXTVAL, 3, SYSDATE, 'Diagnosis 3', 'Treatment 3', 3);
INSERT INTO medical_records (record_id, patient_id, record_date, diagnosis, treatment, doctor_id) VALUES (record_seq.NEXTVAL, 4, SYSDATE, 'Diagnosis 4', 'Treatment 4', 4);
INSERT INTO medical_records (record_id, patient_id, record_date, diagnosis, treatment, doctor_id) VALUES (record_seq.NEXTVAL, 5, SYSDATE, 'Diagnosis 5', 'Treatment 5', 5);
INSERT INTO medical_records (record_id, patient_id, record_date, diagnosis, treatment, doctor_id) VALUES (record_seq.NEXTVAL, 6, SYSDATE, 'Diagnosis 6', 'Treatment 6', 6);
INSERT INTO medical_records (record_id, patient_id, record_date, diagnosis, treatment, doctor_id) VALUES (record_seq.NEXTVAL, 7, SYSDATE, 'Diagnosis 7', 'Treatment 7', 7);
INSERT INTO medical_records (record_id, patient_id, record_date, diagnosis, treatment, doctor_id) VALUES (record_seq.NEXTVAL, 8, SYSDATE, 'Diagnosis 8', 'Treatment 8', 8);
INSERT INTO medical_records (record_id, patient_id, record_date, diagnosis, treatment, doctor_id) VALUES (record_seq.NEXTVAL, 9, SYSDATE, 'Diagnosis 9', 'Treatment 9', 9);
INSERT INTO medical_records (record_id, patient_id, record_date, diagnosis, treatment, doctor_id) VALUES (record_seq.NEXTVAL, 10, SYSDATE, 'Diagnosis 10', 'Treatment 10', 10);

-- Insert values into bed_history table
INSERT INTO bed_history (history_id, patient_id, bed_id, start_date) VALUES (history_seq.NEXTVAL, 1, 1, SYSDATE);
INSERT INTO bed_history (history_id, patient_id, bed_id, start_date) VALUES (history_seq.NEXTVAL, 2, 2, SYSDATE);
INSERT INTO bed_history (history_id, patient_id, bed_id, start_date) VALUES (history_seq.NEXTVAL, 3, 3, SYSDATE);
INSERT INTO bed_history (history_id, patient_id, bed_id, start_date) VALUES (history_seq.NEXTVAL, 4, 4, SYSDATE);
INSERT INTO bed_history (history_id, patient_id, bed_id, start_date) VALUES (history_seq.NEXTVAL, 5, 5, SYSDATE);
INSERT INTO bed_history (history_id, patient_id, bed_id, start_date) VALUES (history_seq.NEXTVAL, 6, 6, SYSDATE);
INSERT INTO bed_history (history_id, patient_id, bed_id, start_date) VALUES (history_seq.NEXTVAL, 7, 7, SYSDATE);
INSERT INTO bed_history (history_id, patient_id, bed_id, start_date) VALUES (history_seq.NEXTVAL, 8, 8, SYSDATE);
INSERT INTO bed_history (history_id, patient_id, bed_id, start_date) VALUES (history_seq.NEXTVAL, 9, 9, SYSDATE);
INSERT INTO bed_history (history_id, patient_id, bed_id, start_date) VALUES (history_seq.NEXTVAL, 10, 10, SYSDATE);



SELECT * FROM rooms;
SELECT * FROM beds;
SELECT * FROM departments;
SELECT * FROM staff;
SELECT * FROM patients;
SELECT * FROM medical_records;
SELECT * FROM bed_history;

SELECT p.patient_id, p.name AS patient_name, p.admission_date, r.room_type, b.bed_status, m.diagnosis, m.treatment
FROM patients p
JOIN rooms r ON r.room_id = p.assigned_bed
JOIN beds b ON b.bed_id = p.assigned_bed
JOIN medical_records m ON m.patient_id = p.patient_id;
