import { Knex } from 'knex';

export async function up(knex: Knex): Promise<void> {
  // Users table
  await knex.schema.createTable('users', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.string('email').unique().notNullable();
    table.string('password').notNullable();
    table.string('firstName').notNullable();
    table.string('lastName').notNullable();
    table.enum('role', ['admin', 'teacher', 'student', 'parent', 'staff']).notNullable();
    table.boolean('isActive').defaultTo(true);
    table.timestamp('lastLogin').nullable();
    table.timestamps(true, true);
    table.index('email');
  });

  // Students table
  await knex.schema.createTable('students', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.string('admissionNumber').unique().notNullable();
    table.string('firstName').notNullable();
    table.string('lastName').notNullable();
    table.string('email').unique().notNullable();
    table.string('phone').notNullable();
    table.date('dateOfBirth').notNullable();
    table.enum('gender', ['Male', 'Female']).notNullable();
    table.string('fatherName').notNullable();
    table.string('motherName').notNullable();
    table.text('address').notNullable();
    table.string('city').notNullable();
    table.date('admissionDate').notNullable();
    table.string('class').notNullable();
    table.string('section').notNullable();
    table.text('idCardQRCode').nullable();
    table.string('photo').nullable();
    table.timestamps(true, true);
    table.index(['admissionNumber', 'class']);
  });

  // Staff table
  await knex.schema.createTable('staff', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.string('employeeId').unique().notNullable();
    table.string('firstName').notNullable();
    table.string('lastName').notNullable();
    table.string('email').unique().notNullable();
    table.string('phone').notNullable();
    table.string('designation').notNullable();
    table.string('department').notNullable();
    table.date('dateOfJoining').notNullable();
    table.decimal('salary', 12, 2).notNullable();
    table.text('idCardQRCode').nullable();
    table.string('photo').nullable();
    table.timestamps(true, true);
    table.index('employeeId');
  });

  // Attendance table
  await knex.schema.createTable('attendance', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('studentId').notNullable().references('id').inTable('students').onDelete('CASCADE');
    table.date('date').notNullable();
    table.enum('status', ['present', 'absent', 'late', 'leave']).notNullable();
    table.uuid('markedBy').nullable();
    table.timestamp('markedAt').notNullable();
    table.enum('method', ['manual', 'qr_scan', 'face_recognition']).notNullable();
    table.timestamps(true, true);
    table.unique(['studentId', 'date']);
    table.index(['studentId', 'date']);
  });

  // Marks table
  await knex.schema.createTable('marks', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('studentId').notNullable().references('id').inTable('students').onDelete('CASCADE');
    table.string('subject').notNullable();
    table.decimal('marks', 5, 2).notNullable();
    table.decimal('maxMarks', 5, 2).defaultTo(100);
    table.string('grade').notNullable();
    table.string('academicYear').notNullable();
    table.uuid('markedBy').notNullable();
    table.timestamp('markedAt').notNullable();
    table.boolean('qrCodeVerified').defaultTo(false);
    table.timestamps(true, true);
    table.unique(['studentId', 'subject', 'academicYear']);
    table.index(['studentId', 'academicYear']);
  });

  // Fees table
  await knex.schema.createTable('fees', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('studentId').notNullable().references('id').inTable('students').onDelete('CASCADE');
    table.decimal('amount', 12, 2).notNullable();
    table.date('dueDate').notNullable();
    table.date('paidDate').nullable();
    table.enum('status', ['pending', 'paid', 'partial']).notNullable().defaultTo('pending');
    table.string('voucherNumber').unique().notNullable();
    table.text('qrCode').nullable();
    table.string('month').notNullable();
    table.integer('year').notNullable();
    table.timestamps(true, true);
    table.unique(['studentId', 'month', 'year']);
    table.index(['studentId', 'year']);
  });

  // Fee Payments table
  await knex.schema.createTable('fee_payments', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('feeId').notNullable().references('id').inTable('fees').onDelete('CASCADE');
    table.decimal('amount', 12, 2).notNullable();
    table.enum('paymentMethod', ['cash', 'check', 'bank_transfer', 'online']).notNullable();
    table.date('paymentDate').notNullable();
    table.uuid('receivedBy').notNullable();
    table.string('receiptNumber').unique().notNullable();
    table.timestamps(true, true);
    table.index(['feeId', 'paymentDate']);
  });

  // Homework table
  await knex.schema.createTable('homework', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.string('title').notNullable();
    table.text('description').notNullable();
    table.uuid('uploadedBy').notNullable();
    table.string('class').notNullable();
    table.string('subject').notNullable();
    table.date('dueDate').notNullable();
    table.string('fileUrl').notNullable();
    table.timestamps(true, true);
    table.index(['class', 'subject', 'dueDate']);
  });

  // Expenses table
  await knex.schema.createTable('expenses', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.string('category').notNullable();
    table.text('description').notNullable();
    table.decimal('amount', 12, 2).notNullable();
    table.date('expenseDate').notNullable();
    table.uuid('recordedBy').notNullable();
    table.string('receiptUrl').nullable();
    table.timestamps(true, true);
    table.index(['category', 'expenseDate']);
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists('expenses');
  await knex.schema.dropTableIfExists('homework');
  await knex.schema.dropTableIfExists('fee_payments');
  await knex.schema.dropTableIfExists('fees');
  await knex.schema.dropTableIfExists('marks');
  await knex.schema.dropTableIfExists('attendance');
  await knex.schema.dropTableIfExists('staff');
  await knex.schema.dropTableIfExists('students');
  await knex.schema.dropTableIfExists('users');
}
