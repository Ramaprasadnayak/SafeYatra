// Unique districts available in the Saafe Yatra crime dataset.
// Total unique districts: 360

const List<String> districts = [
  "Ahmadabad", // tested
  "Ahmednagar", // tested
  "Aizawl", // tested
  "Aligarh", //tested
  "Almora", //tested
  "Alwar", //tested
  "Ambala", //tested
  "Amritsar", //tested
  "Anjaw", //tested
  "Anugul", //tested
  "Anuppur",//tested
  "Araria",//tested
  "Arwal", //tested
  "Ashoknagar", //tested
  "Auraiya", //tested
  "Bagalkote",//tested
  "Bageshwar", //tested
  "Bahraich", //tested
  "Baksa", //tested
  "Balangir", //tested
  "Baleshwar", //tested
  "Ballia", //tested
  "Balrampur", //tested
  "Banka", //tested
  "Baramulla", //tested
  "Bargarh",  //tested
  "Barmer", //tested
  "Barpeta", //tested
  "Begusarai", //tested
  // "Belagavi", //no prediction
  // "Bengaluru Urban", //no prediction
  "Betul", // tested
  "Bhadrak", // tested
  "Bhagalpur", //tested
  "Bhandara", //tested
  "Bharatpur", //tested
  "Bharuch",//tested
  "Bhind",//tested
  "Bhojpur",//tested
  "Bhopal",//tested
  "Bidar",//tested
  "Bijnor",//tested
  "Bikaner",//tested
  "Bishnupur",//tested
  "Bokaro",//tested
  "Bongaigaon",//tested
  "Budgam",//tested
  "Bulandshahr",//tested
  "Burhanpur",//tested
  "Chamoli",//tested
  "Champawat",//tested
  "Chandigarh",//tested
  "Changlang",//tested
  "Chatra",//tested
  "Chennai",//tested
  "Chhatrapati Sambhajinagar",// tested
  // "Chhotaudepur",// no prediction
  "Chikkamagaluru",//tested
  "Chittorgarh",//tested
  "Coimbatore", // tested
  "Cuttack", // tested
  // "Dadra And Nagar Haveli", //no prediction
  "Dakshina Kannada",// tested
  "Darbhanga",//tested
  "Darjeeling",//tested
  "Datia",//tested
  "Dausa", //tested
  "Deogarh",// tested
  "Deoria",// tested
  "Dhamtari",// tested
  "Dhanbad",// tested
  "Dhar",//tested
  // "Dharashiv",// no boundary
  "Dharwad",//tested
  "Dhenkanal",//tested
  "Dibrugarh",//tested
  "Dima Hasao",//tested
  "Dimapur",//tested
  // "Diu",// no prediction
  "Durg",//tested
  // "East Singhbum", no prediction
  "Etah",//tested
  "Faridkot",// tested
  "Fatehgarh Sahib",//tested
  "Fatehpur", // tested
  "Firozabad", // tested
  "Gadchiroli",// tested
  "Ganderbal",// tested
  "Ganganagar",// tested
  // "Gangtok", no prediction 
  // "Gariyaband",no prediction
  "Gautam Buddha Nagar",//tested
  "Gaya", //tested
  "Ghaziabad",//tested
  "Ghazipur",//tested
  "Giridih",//tested
  // "Gomati",//no prediction
  "Gopalganj",//tested
  "Gorakhpur",//tested
  "Gurdaspur",//tested
  // "Gurugram",no prediction
  "Gyalshing",// tested
  "Hailakandi",// tested
  "Hamirpur", //tested
  "Hardoi", // tested
  "Hassan",// tested
  "Haveri",// tested
  "Hingoli",//tested
  "Hisar",//tested
  // "Hojai",no prediction
  "Hooghly",//tested
  "Howrah",// tested
  "Hyderabad",//tested
  "Idukki",//tested
  "Imphal West",//tested
  "Indore",//tested
  "Jabalpur",//tested
  // "Jagitial",//no prediction
  "Jaipur",// tested
  "Jajapur",// tested
  "Jalaun",// tested
  "Jalna",// tested
  "Jammu", // tested
  "Jamnagar", // tested
  "Jamui", // tested
  "Jashpur",// tested
  "Jaunpur",//tested
  // "Jayashankar Bhupalapally",// no prediction
  "Jehanabad",// tested
  "Jhalawar",// tested
  // "Jhargram",// no prediction
  "Jhunjhunu",//tested
  // "Jiribam", // no prediction
  "Jodhpur",//tested
  "Kachchh", // tested
  // "Kakching",// no prediction
  "Kakinada",//tested
  "Kalahandi",//tested
  "Kamareddy",//tested
  "Kamrup",//tested
  "Kandhamal",//tested
  // "Kangpokpi",//no prediction
  "Kanpur Dehat",//tested
  "Kanpur Nagar",//tested
  "Kapurthala",//tested
  "Karimnagar",//tested
  "Kasaragod",//tested
  // "Kasganj",//no prediction
  "Kathua",//tested
  "Katni",//tested
  "Kendrapara",//tested
  "Kendujhar",//tested
  "Khairthal-Tijara",//tested
  "Kheda",//tested
  "Kinnaur",//tested
  "Kiphire",//tested
  "Kishanganj",//tested
  "Kishtwar",//tested
  "Kohima",//tested
  "Kolar",//tested
  "Kollam",//tested
  // "Kondagaon",//no prediction
  // "Kra Daadi",no prediction
  "Krishna",//tested
  // "Kushinagar",//no boundary
  "Lakhimpur",//tested
  "Lalitpur",//tested
  "Latur",//tested
  "Lawngtlai",//tested
  "Lohardaga",//tested
  "Lohitpur",//tested
  // "Longding",no prediction
  "Lower Dibang Valley",//tested
  "Lower Subansiri",//tested
  "Lucknow",//tested
  "Ludhiana",//tested
  "Madhepura",//tested
  "Madhubani",//tested
  "Madurai",//tested
  "Mahabubabad",//tested
  "Mahabubnagar",//tested
  "Mahasamund",//tested
  "Mahesana",//tested
  // "Mahisagar",//no prediction
  "Mahoba",//tested
  // "Mahrajganj",no boundary
  "Malappuram",//tested
  // "Malda",//no boundary
  "Mandla",//tested
  "Mandya",//tested
  "Mansa",//tested
  "Mau",//tested
  "Mayurbhanj",//tested
  "Medak",//tested
  "Meerut",//tested
  "Mirzapur",//tested
  "Moga",//tested
  "Mokokchung",//tested
  "Moradabad",//tested
  "Mumbai",//tested
  "Mumbai Suburban",//tested
  "Munger",//tested
  "Murshidabad",//tested
  "Muzaffarpur",//tested
  "Nadia",//tested
  "Nagaon",//tested
  "Nagapattinam",//tested
  "Nagarkurnool",//tested
  "Nagaur",//tested
  "Nagpur",//tested
  "Nainital",//tested
  "Nalbari",//tested
  "Nalgonda",//tested
  "Nandurbar",//tested
  "Narayanpur",//tested
  "Narmada",//tested
  // "Narmadapuram",no prediction
  "Navsari",//tested
  "Nawada",//tested
  "Neemuch",//tested
  "New Delhi",//tested
  "Nizamabad",//tested
  // "Noney",no prediction
  "North",//tested
  "North And Middle Andaman",//tested
  "North Garo Hills",//tested
  "North Goa",//tested
  "North West",//tested
  "Palakkad",//tested
  "Palamu",//tested
  "Panch Mahals",//tested
  "Panchkula",//tested
  "Panna",//tested
  "Papum Pare",//tested
  "Parbhani",//tested
  "Pashchim Champaran",//tested
  // "Pathankot", no prediction
  "Patiala",//tested
  "Patna",//tested
  "Pauri Garhwal",//tested
  // "Peddapalli",no prediction
  "Phek",//tested
  "Pondicherry",//tested
  "Prakasam",//tested
  // "Prayagraj",no prediction
  "Pulwama",//tested
  "Pune",//tested
  // "Purba Medinipur", no boundary
  "Purnia",//tested
  "Purulia",//tested
  "Rae Bareli",//tested
  "Raichur",//tested
  "Raigarh",//tested
  "Raipur",//tested
  // "Rajanna Sircilla",no prediction
  "Rajgarh",//tested
  "Rajkot",//tested
  "Rajnandgaon",//tested
  "Rajsamand",//tested
  "Ramanagara",//tested
  "Ramgarh",//tested
  "Ranchi",//tested
  "Ratnagiri",//tested
  "Reasi",//tested
  "Rewari",//tested
  "Rohtak",//tested
  "Rohtas",//tested
  "Rudra Prayag",//tested
  "S.A.S Nagar",//tested
  "Saharanpur",//tested
  "Saharsa",//tested
  "Salem",//tested
  "Samastipur",//tested
  "Samba",//tested
  // "Sambhal",no prediction
  "Sangareddy",//tested
  "Sangli",//tested
  "Sangrur",//tested
  // "Sant Kabir Nagar,//no boundary"
  "Satara",//tested
  // "Shahdara",//no prediction
  "Shahid Bhagat Singh Nagar",// tested
  "Shahjahanpur",// tested
  "Sheohar",//tested
  // "Shi Yomi",no prediction
  "Shimla",//tested
  "Shopian",//tested
  // "Shrawasti",//no boundary
  // "Siang", no prediction
  // "Siddharthnagar",no boundary
  // "Siddipet",//no prediction
  "Sindhudurg",// tested
  "Sirohi",// tested
  "Sirsa",// tested
  "Sitamarhi",//tested
  "Sivaganga",//tested
  "Solan",//tested
  "Solapur",//tested
  "Sonipat",//tested
  "Sonitpur",//tested
  "South Andamans",// tested
  "South Garo Hills",// tested
  // "South Salmara Mancachar",//no prediction
  "South Tripura",//tested
  "South West najafgarh",//tested
  "Sri Muktsar Sahib",//tested
  // "Sri Potti Sriramulu Nellore",//no boundary
  "Srikakulam",//tested
  "Srinagar",//tested
  "Sundargarh",//tested
  "Surat",//tested
  "Surguja",//tested
  "Tamenglong",//tested
  "Tarn Taran",//tested
  // "Tengnoupal",no prediction
  "Thanjavur",//tested
  "The Nilgiris",//tested
  "Thiruvallur",//tested
  "Thiruvananthapuram",//tested
  "Thiruvarur",//tested
  "Thrissur",//tested
  "Tiruchirappalli",//tested
  "Tirunelveli",//tested
  "Tuensang",//tested
  "Tumakuru",//tested
  "Udam Singh Nagar",//tested
  "Udhampur",// tested
  "Udupi", // tested
  "Ujjain",// tested
  "Ukhrul",//tested
  // "Unakoti",//no prediction
  "Upper Siang",//tested
  "Upper Subansiri",//tested
  // "Uttar Bastar Kanker",//no boundary
  // "Uttar Dinajpur",//no boundary
  "Uttar Kashi",//tested
  "Vadodara", // tested
  "Varanasi",// tested
  "Villupuram",// tested
  "Virudhunagar",// tested
  // "Visakhapatnam", //no boundary
  "Warangal", // tested
  "Wayanad",// tested
  "West Jaintia Hills",// tested
  "West Karbi Anglong", // tested
  "West Khasi Hills",// tested
  "Yadgir", // tested
];
