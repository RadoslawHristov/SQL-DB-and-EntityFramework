using System;
using System.Linq;
using System.Text;
using SoftUni.Data;
using SoftUni.Models;


namespace SoftUni
{
    public class StartUp
    {
        public static void Main(string[] args)
        {
            var context = new SoftUniContext();
            var result = RemoveTown(context);
            Console.WriteLine(result);
            
        }


        public static string RemoveTown(SoftUniContext context)
        {
           

            context.Employees
                .Where(e => e.Address.Town.Name == "Seattle")
                .ToList()
                .ForEach(e => e.AddressId = null);

            int addressesCount = context.Addresses
                .Where(a => a.Town.Name == "Seattle")
                .Count();

            context.Addresses
                .Where(a => a.Town.Name == "Seattle")
                .ToList()
                .ForEach(a => context.Addresses.Remove(a));

            context.Towns
                .Remove(context.Towns
                    .SingleOrDefault(t => t.Name == "Seattle"));

            context.SaveChanges();
            
            return ($"{addressesCount} {(addressesCount == 1 ? "address" : "addresses")} in {"Seattle"} {(addressesCount == 1 ? "was" : "were")} deleted");
        }
        public static string DeleteProjectById(SoftUniContext context)
        {
            StringBuilder sa = new StringBuilder();

            var delProjAndEmpl = context.EmployeesProjects
                .Where(x=>x.ProjectId == 2).ToList();

            context.EmployeesProjects.RemoveRange(delProjAndEmpl);

            var delProj = context.Projects
                .Where(x => x.ProjectId == 2).ToList();

            context.Projects.RemoveRange(delProj);

            context.SaveChanges();

            var project = context.Projects
                .Take(10)
                .Select(x => x.Name)
                .ToList();

            foreach (var pro in project)
            {
                sa.AppendLine(pro);
            }




            return sa.ToString().TrimEnd();
        }
        public static string GetEmployeesByFirstNameStartingWithSa(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var allEmployees = context.Employees
                .Where(x => x.FirstName.StartsWith("Sa"))
                .OrderBy(x => x.FirstName)
                .ThenBy(x => x.LastName)
                .Select(x => new
                {
                    x.FirstName,
                    x.LastName,
                    x.JobTitle,
                    x.Salary
                })
                .ToList();

            foreach (var employee in allEmployees)
            {
                sb.AppendLine($"{employee.FirstName} {employee.LastName} - {employee.JobTitle} - (${employee.Salary:f2})");
            }


            return sb.ToString().TrimEnd();
        }
        public static string IncreaseSalaries(SoftUniContext context)
        {
            StringBuilder sl =new StringBuilder();

            var update = context.Employees
                .Where(e => new[] { "Engineering", "Tool Design", "Marketing", "Information Services" }
                    .Contains(e.Department.Name))
                .ToList();

              update.ForEach(e=>e.Salary *=1.12m);
                //.ForEach(e => e.Salary *= 1.12m);

            context.SaveChanges();

             var result = context.Employees
                .Where(e => new[] { "Engineering", "Tool Design", "Marketing", "Information Services" }
                    .Contains(e.Department.Name))
                .OrderBy(e => e.FirstName)
                .ThenBy(e => e.LastName)
                .ToList();

            foreach (var people in result)
            {
                sl.AppendLine($"{people.FirstName} {people.LastName} (${people.Salary:f2})");
            }

            return sl.ToString().TrimEnd();
        }
        public static string GetLatestProjects(SoftUniContext context)
        {

            StringBuilder sa = new StringBuilder();

            StringBuilder result = new StringBuilder();
            
            var projects = context.Projects.OrderByDescending(p => p.StartDate).Take(10).Select(s => new
            {
                ProjectName = s.Name,
                ProjectDescription = s.Description,
                ProjectStartDate = s.StartDate
            }).OrderBy(n => n.ProjectName).ToArray();
            
            foreach (var p in projects)
            {
                var startDate = p.ProjectStartDate.ToString("M/d/yyyy h:mm:ss tt");
                result.AppendLine($"{p.ProjectName}");
                result.AppendLine($"{p.ProjectDescription}");
                result.AppendLine($"{startDate}");
            }
            return result.ToString().TrimEnd();


            //var projects = context.Projects
            //    .OrderByDescending(x=>x.StartDate)
            //    .Take(10)
            //    .Select(p => new
            //    {
            //        ProjectName = p.Name,
            //        Description = p.Description,
            //        StartDate = p.StartDate
            //    })
            //    .OrderBy(x=>x.ProjectName)
            //    .ToList();
            //
            //foreach (var pro in projects)
            //{
            //    sa.AppendLine($"{pro.ProjectName}");
            //    sa.AppendLine($"{pro.Description}");
            //    sa.AppendLine($"{pro.StartDate.ToString("M/d/yyyy h:mm:ss tt")} AM");
            //}
            //
            //return sa.ToString().TrimEnd();
        }
        public static string GetDepartmentsWithMoreThan5Employees(SoftUniContext context)
        {

            StringBuilder sb = new StringBuilder();

            var deparments = context.Departments
                .Where(d => d.Employees.Count > 5)
                .OrderBy(d => d.Employees.Count)
                .Select(d => new
                {
                    DepartmentName = d.Name,
                    managerFirstName = d.Manager.FirstName,
                    managerLastName = d.Manager.LastName,
                    employees = d.Employees
                        .OrderBy(x => x.FirstName)
                        .ThenBy(x => x.LastName)
                        .Select(e => new
                        {
                            e.FirstName,
                            e.LastName,
                            e.JobTitle
                        })
                })
                .ToList();

            foreach (var dep in deparments)
            {
                sb.AppendLine($"--{dep.DepartmentName} - {dep.managerFirstName} {dep.managerLastName}");

                foreach (var emp in dep.employees)
                {
                    sb.AppendLine($"{emp.FirstName} {emp.LastName} - {emp.JobTitle}");
                }
            }



            return sb.ToString().TrimEnd();
        }
        public static string GetEmployee147(SoftUniContext context)
        {

            StringBuilder bilder = new StringBuilder();

            var EmployeeForId = context.Employees
                .Where(x => x.EmployeeId == 147)
                .Select(x => new
                {
                    x.FirstName,
                    x.LastName,
                    x.JobTitle,
                    AllProjects = context.EmployeesProjects
                        .Where(x => x.EmployeeId == 147)
                        .Select(e => new
                        {
                            ProjectName = e.Project.Name
                        })
                        .OrderBy(e => e.ProjectName)
                        .ToList()

                }).ToList();


            foreach (var emp in EmployeeForId)
            {
                bilder.AppendLine($"{emp.FirstName} {emp.LastName} - {emp.JobTitle}");

                foreach (var pro in emp.AllProjects)
                {
                    bilder.AppendLine($"{pro.ProjectName}");
                }
            }


            return bilder.ToString().TrimEnd();
        }
        public static string GetAddressesByTown(SoftUniContext context)
        {
            StringBuilder sv = new StringBuilder();

            var Allpeople = context.Addresses
                .OrderByDescending(x => x.Employees.Count)
                .ThenBy(x => x.Town.Name)
                .ThenBy(x => x.AddressText)
                .Take(10)
                .Select(x => new
                {
                    EmplCount = x.Employees.Count(),
                    x.AddressText,
                    TownName = x.Town.Name,
                })
                .ToList();


            foreach (var people in Allpeople)
            {
                sv.AppendLine($"{people.AddressText}, {people.TownName} - {people.EmplCount} employees");
            }

            return sv.ToString().TrimEnd();
        }
        public static string GetEmployeesInPeriod(SoftUniContext context)
        {
            StringBuilder sv = new StringBuilder();

            var AllProjects = context.Employees
                .Where(e => e.EmployeesProjects.Any(ep => ep.Project.StartDate.Year >= 2001 &&
                                                                          ep.Project.StartDate.Year <= 2003))
                .Take(10)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    MenagerFirstName = e.Manager.FirstName,
                    MenagerLastName = e.Manager.LastName,
                    AllProjects = e.EmployeesProjects
                        .Select(ep => new
                        {
                            ProjectName = ep.Project.Name,
                            StartDate = ep.Project.StartDate.ToString("M/d/yyyy h:mm:ss tt"),
                            EndDate = ep.Project.EndDate.HasValue ? ep.Project.EndDate.Value.ToString("M/d/yyyy h:mm:ss tt")
                                : "not finished"
                        }).ToList()
                })
                .ToList();

            foreach (var e in AllProjects)
            {
                sv.AppendLine($"{e.FirstName} {e.LastName} - Manager: {e.MenagerFirstName} {e.MenagerLastName}");

                foreach (var ep in e.AllProjects)
                {
                    sv.AppendLine($"--{ep.ProjectName} - {ep.StartDate} - {ep.EndDate}");
                }
            }



            return sv.ToString().TrimEnd();
        }
        public static string AddNewAddressToEmployee(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            Address newAdress = new Address()
            {
                AddressText = "Vitoshka 15",
                TownId = 4
            };
            context.Addresses.Add(newAdress);

            Employee findNakov = context.Employees
                .First(x => x.LastName == "Nakov");

            findNakov.Address = newAdress;
            context.SaveChanges();

            var adresInfo = context.Employees
                .OrderByDescending(x => x.AddressId)
                .Take(10)
                .Select(x => x.Address.AddressText)
                .ToList();

            foreach (var info in adresInfo)
            {
                sb.AppendLine(info);
            }

            return sb.ToString().TrimEnd();
        }
        public static string GetEmployeesFromResearchAndDevelopment(SoftUniContext context)
        {

            StringBuilder sv = new StringBuilder();

            var allEmploeesResult = context.Employees
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    DepartmentName = e.Department.Name,
                    e.Salary
                })
                .Where(x => x.DepartmentName == "Research and Development")
                .OrderBy(x => x.Salary).ThenByDescending(x => x.FirstName)
                .ToList();

            foreach (var dep in allEmploeesResult)
            {
                sv.AppendLine($"{dep.FirstName} {dep.LastName} from {dep.DepartmentName} - ${dep.Salary:f2}");
            }
            return sv.ToString().TrimEnd();
        }
        public static string GetEmployeesWithSalaryOver50000(SoftUniContext context)
        {

            StringBuilder sv = new StringBuilder();

            var allSalary = context.Employees
                .Select(e => new
                {
                    e.FirstName,
                    e.Salary
                })
                .Where(e => e.Salary > 50000)
                .OrderBy(e => e.FirstName)
                .ToList();

            foreach (var people in allSalary)
            {
                sv.AppendLine($"{people.FirstName} - {people.Salary:f2}");
            }

            return sv.ToString().TrimEnd();
        }
        public static string GetEmployeesFullInformation(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var allEmployee = context.Employees
                .Select(x => new
                {
                    x.EmployeeId,
                    x.FirstName,
                    x.LastName,
                    x.MiddleName,
                    x.JobTitle,
                    x.Salary
                })
                .OrderByDescending(x => x.EmployeeId)
                .ToList();

            foreach (var employee in allEmployee)
            {
                sb.AppendLine($"{employee.FirstName} {employee.LastName} {employee.MiddleName} {employee.JobTitle} {employee.Salary:f2}");
            }
            var rest = sb.ToString().TrimEnd();
            return rest;
        }
    }
}
