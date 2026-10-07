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
  "Bharuch",
  "Bhind",
  "Bhojpur",
  "Bhopal",
  "Bidar",
  "Bijnor",
  "Bikaner",
  "Bishnupur",
  "Bokaro",
  "Bongaigaon",
  "Budgam",
  "Bulandshahr",
  "Burhanpur",
  "Chamoli",
  "Champawat",
  "Chandigarh",
  "Changlang",
  "Chatra",
  "Chennai",
  "Chhatrapati Sambhajinagar",
  "Chhotaudepur",
  "Chikkamagaluru",//tested
  "Chittorgarh",
  "Coimbatore", // tested
  "Cuttack", // tested
  // "Dadra And Nagar Haveli", //no prediction
  "Dakshina Kannada",// tested
  "Darbhanga",//tested
  "Darjeeling",
  "Datia",
  "Dausa",
  "Deogarh",
  "Deoria",
  "Dhamtari",
  "Dhanbad",
  "Dhar",
  "Dharashiv",
  "Dharwad",
  "Dhenkanal",
  "Dibrugarh",
  "Dima Hasao",
  "Dimapur",
  "Diu",
  "Durg",
  "East Singhbum",
  "Etah",
  "Faridkot",
  "Fatehgarh Sahib",//tested
  "Fatehpur", // tested
  "Firozabad", // tested
  "Gadchiroli",
  "Ganderbal",
  "Ganganagar",
  "Gangtok",
  "Gariyaband",
  "Gautam Buddha Nagar",//tested
  "Gaya", //tested
  "Ghaziabad",//tested
  "Ghazipur",
  "Giridih",
  "Gomati",
  "Gopalganj",
  "Gorakhpur",
  "Gurdaspur",
  "Gurugram",
  "Gyalshing",
  "Hailakandi",
  "Hamirpur", //tested
  "Hardoi", // tested
  "Hassan",
  "Haveri",
  "Hingoli",
  "Hisar",
  "Hnahthial",
  "Hojai",
  "Hooghly",
  "Howrah",
  "Hyderabad",
  "Idukki",
  "Imphal West",
  "Indore",
  "Jabalpur",
  "Jagitial",
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
  "Kalahandi",
  "Kamareddy",
  "Kamrup",
  "Kandhamal",
  "Kangpokpi",
  "Kanpur Dehat",
  "Kanpur Nagar",
  "Kapurthala",
  "Karimnagar",
  "Kasaragod",
  "Kasganj",
  "Kathua",
  "Katni",
  "Kendrapara",
  "Kendujhar",
  "Khairthal-Tijara",
  "Khawzawl",
  "Kheda",
  "Kinnaur",//tested
  "Kiphire",
  "Kishanganj",
  "Kishtwar",
  "Kohima",
  "Kolar",
  "Kollam",
  "Kondagaon",
  "Kra Daadi",
  "Krishna",
  "Kushinagar",
  "Lakhimpur",
  "Lalitpur",
  "Latur",
  "Lawngtlai",
  "Lohardaga",
  "Lohit",
  "Longding",
  "Lower Dibang Valley",
  "Lower Subansiri",
  "Lucknow",
  "Ludhiana",
  "Madhepura",
  "Madhubani",
  "Madurai",
  "Mahabubabad",
  "Mahabubnagar",
  "Mahasamund",
  "Mahesana",
  "Mahisagar",
  "Mahoba",
  "Mahrajganj",
  "Malappuram",
  "Malda",
  "Mandla",
  "Mandya",
  "Mansa",
  "Mau",
  "Mayurbhanj",
  "Medak",
  "Meerut",
  "Mirzapur",
  "Moga",
  "Mokokchung",
  "Moradabad",
  "Mumbai",
  "Mumbai Suburban",
  "Munger",
  "Murshidabad",
  "Muzaffarpur",
  "Nadia",
  "Nagaon",
  "Nagapattinam",
  "Nagarkurnool",
  "Nagaur",
  "Nagpur",
  "Nainital",
  "Nalbari",
  "Nalgonda",
  "Nandurbar",
  "Narayanpur",
  "Narmada",
  "Narmadapuram",
  "Navsari",
  "Nawada",
  "Neemuch",
  "New Delhi",
  "Nizamabad",
  "Noney",
  "North",
  "North And Middle Andaman",//tested
  "North Garo Hills",
  "North Goa",
  "North West",
  "Palakkad",
  "Palamu",
  "Panch Mahals",
  "Panchkula",
  "Panna",
  "Papum Pare",
  "Parbhani",
  "Pashchim Champaran",
  // "Pathankot", no prediction
  "Patiala",
  "Patna",
  "Pauri Garhwal",
  "Peddapalli",
  "Phek",
  "Pondicherry",
  "Prakasam",
  "Prayagraj",
  "Pulwama",
  "Pune",//tested
  // "Purba Medinipur", no boundary
  "Purnia",
  "Purulia",
  "Rae Bareli",
  "Raichur",
  "Raigarh",
  "Raipur",
  "Rajanna Sircilla",
  "Rajgarh",
  "Rajkot",
  "Rajnandgaon",
  "Rajsamand",
  "Ramanagara",
  "Ramgarh",
  "Ranchi",
  "Ratnagiri",
  "Reasi",
  "Rewari",
  "Rohtak",
  "Rohtas",
  "Rudra Prayag",
  "S.A.S Nagar",
  "Saharanpur",
  "Saharsa",
  "Salem",
  "Samastipur",
  "Samba",
  "Sambhal",
  "Sangareddy",
  "Sangli",
  "Sangrur",
  "Sant Kabir Nagar",
  "Satara",
  "Shahdara",
  "Shahid Bhagat Singh Nagar",// tested
  "Shahjahanpur",// tested
  "Sheohar",
  "Shi Yomi",
  "Shimla",
  "Shopian",
  "Shrawasti",
  "Siang",
  "Siddharthnagar",
  "Siddipet",
  "Sindhudurg",
  "Sirohi",
  "Sirsa",// tested
  "Sitamarhi",
  "Sivaganga",
  "Solan",
  "Solapur",
  "Sonipat",
  "Sonitpur",
  "South Andamans",// tested
  "South Garo Hills",// tested
  "South Salmara Mancachar",
  "South Tripura",
  "South West",
  "Sri Muktsar Sahib",
  "Sri Potti Sriramulu Nellore",
  "Srikakulam",
  "Srinagar",
  "Sundargarh",
  "Surat",
  "Surguja",
  "Tamenglong",
  "Tarn Taran",
  "Tengnoupal",
  "Thanjavur",
  "The Nilgiris",
  "Thiruvallur",
  "Thiruvananthapuram",
  "Thiruvarur",
  "Thrissur",
  "Tiruchirappalli",
  "Tirunelveli",
  "Tirupati",
  "Tuensang",
  "Tumakuru",
  "Udam Singh Nagar",
  "Udhampur",
  "Udupi", // tested
  "Ujjain",
  "Ukhrul",
  "Unakoti",
  "Upper Siang",
  "Upper Subansiri",
  "Uttar Bastar Kanker",
  "Uttar Dinajpur",
  "Uttar Kashi",
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
