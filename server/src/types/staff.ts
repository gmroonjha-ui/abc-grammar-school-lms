export interface Staff {
  id: string;
  employeeId: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  designation: string;
  department: string;
  dateOfJoining: Date;
  salary: number;
  idCardQRCode: string;
  photo: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface StaffInput {
  employeeId: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  designation: string;
  department: string;
  dateOfJoining: Date;
  salary: number;
}
