
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('ADMIN', 'DOCTOR', 'RECEPTIONIST', 'PATIENT')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE department (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE patient (
    patient_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    phone VARCHAR(20),
    address TEXT,

    CONSTRAINT fk_patient_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE doctor (
    doctor_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    name VARCHAR(100),
    department_id INT NOT NULL,
    qualification VARCHAR(150),
    experience INT,

    CONSTRAINT fk_doctor_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_doctor_department
        FOREIGN KEY (department_id)
        REFERENCES department(department_id)
        ON DELETE RESTRICT
);


CREATE TABLE appointment (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    time_slot VARCHAR(50) NOT NULL,
    status VARCHAR(50) CHECK (status IN ('BOOKED', 'COMPLETED', 'CANCELLED')),

    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctor(doctor_id)
        ON DELETE CASCADE
);

CREATE UNIQUE INDEX unique_doctor_schedule
ON appointment (doctor_id, appointment_date, time_slot);

CREATE TABLE prescription (
    prescription_id SERIAL PRIMARY KEY,
    appointment_id INT UNIQUE NOT NULL,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    diagnosis TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_prescription_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_prescription_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctor(doctor_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_prescription_patient
        FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
        ON DELETE CASCADE
);


CREATE TABLE medicine (
    medicine_id SERIAL PRIMARY KEY,
    prescription_id INT NOT NULL,
    name VARCHAR(100),
    dosage_morning VARCHAR(50),
    dosage_afternoon VARCHAR(50),
    dosage_night VARCHAR(50),
    duration_days INT,
    instructions TEXT,

    CONSTRAINT fk_medicine_prescription
        FOREIGN KEY (prescription_id)
        REFERENCES prescription(prescription_id)
        ON DELETE CASCADE
);


CREATE TABLE billing (
    bill_id SERIAL PRIMARY KEY,
    appointment_id INT UNIQUE NOT NULL,
    patient_id INT NOT NULL,
    amount DECIMAL(10,2),
    payment_status VARCHAR(50) CHECK (payment_status IN ('PAID', 'PENDING')),
    visit_type VARCHAR(50) CHECK (visit_type IN ('FIRST_VISIT', 'FOLLOW_UP')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_billing_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_billing_patient
        FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
        ON DELETE CASCADE
);


CREATE TABLE reception_log (
    log_id SERIAL PRIMARY KEY,
    receptionist_id INT NOT NULL,
    patient_id INT NOT NULL,
    action VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reception_user
        FOREIGN KEY (receptionist_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_reception_patient
        FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
        ON DELETE CASCADE
);


CREATE INDEX idx_patient_id ON appointment(patient_id);
CREATE INDEX idx_doctor_id ON appointment(doctor_id);
CREATE INDEX idx_appointment_date ON appointment(appointment_date);
CREATE INDEX idx_prescription_patient ON prescription(patient_id);




INSERT INTO users (username, password, role) VALUES
('admin1', 'pass123', 'ADMIN'),
('doc1', 'pass123', 'DOCTOR'),
('doc2', 'pass123', 'DOCTOR'),
('reception1', 'pass123', 'RECEPTIONIST'),
('patient1', 'pass123', 'PATIENT'),
('patient2', 'pass123', 'PATIENT');


INSERT INTO department (name) VALUES
('Cardiology'),
('Neurology'),
('Orthopedics');


INSERT INTO patient (user_id, name, age, gender, phone, address) VALUES
(5, 'Rahul Sharma', 28, 'Male', '9876543210', 'Mumbai'),
(6, 'Priya Singh', 32, 'Female', '9123456780', 'Delhi');


INSERT INTO doctor (user_id, name, department_id, qualification, experience) VALUES
(2, 'Dr. Amit Kumar', 1, 'MBBS, MD', 8),
(3, 'Dr. Neha Verma', 2, 'MBBS, Neurologist', 10);


INSERT INTO appointment (patient_id, doctor_id, appointment_date, time_slot, status) VALUES
(1, 1, '2026-03-28', '10:00-10:30', 'BOOKED'),
(2, 2, '2026-03-29', '11:00-11:30', 'COMPLETED');

INSERT INTO prescription (appointment_id, doctor_id, patient_id, diagnosis, notes) VALUES
(2, 2, 2, 'Migraine', 'Take rest and avoid stress');


INSERT INTO medicine (prescription_id, name, dosage_morning, dosage_afternoon, dosage_night, duration_days, instructions) VALUES
(1, 'Paracetamol', '1', '0', '1', 5, 'After food');


INSERT INTO billing (appointment_id, patient_id, amount, payment_status, visit_type) VALUES
(1, 1, 500.00, 'PENDING', 'FIRST_VISIT'),
(2, 2, 800.00, 'PAID', 'FOLLOW_UP');

INSERT INTO reception_log (receptionist_id, patient_id, action) VALUES
(4, 1, 'REGISTERED_PATIENT'),
(4, 2, 'BOOKED_APPOINTMENT');


