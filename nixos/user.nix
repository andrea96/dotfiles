let 
  notebook = true;
in
{
  username = "andrea";
  name = "Andrea Ciceri";
  email = "andrea.ciceri@autistici.org";
  hostname = if notebook then "notebook" else "pc";
  githubUsername = "aciceri";
  
  gpgKey = "andrea.ciceri@autistici.org";
  gpgSshKeygrip = "CE2FD0D9BECBD8876811714925066CC257413416";
}
