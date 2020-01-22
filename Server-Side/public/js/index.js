var firebaseConfig = 
{
  apiKey: "AIzaSyD4XNHQvPAAR7VXus1PGSXAJ6AKhkRIawk",
  authDomain: "microinloan.firebaseapp.com",
  databaseURL: "https://microinloan.firebaseio.com",
  projectId: "microinloan",
  storageBucket: "microinloan.appspot.com",
  messagingSenderId: "585360852088",
  appId: "1:585360852088:web:3611f25e00ca297305598d",
  measurementId: "G-3Q5RKMML6L"
};
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
  //firebase.initializeApp(config);
  //firebase.analytics();


  firebase.auth.Auth.Persistence.LOCAL;


  $("#btn-login").click(function()
  {
    var email = $("#email").val();
    var password = $("#password").val();

    if(email != "" && password != "")
    {
        var result = firebase.auth().signInWithEmailAndPassword(email,password);

        result.catch(function(error)
        {
            var errorCode = error.code;
            var errorMessage = error.message;

            console.log(errorCode);
            console.log(errorMessage);

            window.alert("Message : " + errorMessage);
        });
    }
    else
    {
       window.alert("Form is not complete."); 
    }

  });




  $("#btn-signup").click(function()
  {
    var email = $("#email").val();
    var password = $("#password").val();
    var cPassword = $("#confirmPassword").val();

    if(email != "" && password != "" && cPassword != "")
    {
        if(password == cPassword)
        {
          var result = firebase.auth().createUserWithEmailAndPassword(email,password);

        result.catch(function(error)
        {
            var errorCode = error.code;
            var errorMessage = error.message;

            console.log(errorCode);
            console.log(errorMessage);

            window.alert("Message : " + errorMessage);
        });
        }
        else
        {
          window.alert("Password do not match with the Confirm password!"); 
        }
    }
    else
    {
       window.alert("Form is not complete."); 
    }

  });



  $("#btn-resetPassword").click(function()
  {
     var auth = firebase.auth();
     var email = $("#email").val();
   
     if(email != "")
     {
       auth.sendPasswordResetEmail(email).then(function()
       {
        window.alert("Email has been sent to you, Please check and verify. ")
       })
       .catch(function(error)
       {
        var errorCode = error.code;
        var errorMessage = error.message;

        console.log(errorCode);
        console.log(errorMessage);

        window.alert("Message : " + errorMessage);
       });
     }
     else
     { 
       window.alert("Please enter your email first.");
     }

  });



  $("#btn-logout").click(function()
  {
   firebase.auth().signOut(); 

  });



  $("#btn-update").click(function()
  {
    var phone = $("#phone").val();
    var address = $("#address").val();
    var bio = $("#bio").val();
    var fName = $("#firstName").val();
    var sName = $("#secondName").val();
    var country = $("#country").val();
    var gender = $("#gender").val();

    var rootRef = firebase.database().ref().child("admin");
    var userId = firebase.auth().currentUser.uid;
    var usersRef = rootRef.child(userId);

    if(fName!="" && sName!="" && phone!="" && bio!="" && address!="" && country!="" && gender!="")
    {
      var userData = 
      {
        "phone": phone,
        "address": address,
        "bio": bio,
        "fName": fName,
        "sName": sName,
        "country": country,
        "gender": gender,
      };
      usersRef.set(userData, function(error)
      {
        if(error)
        {
          var errorCode = error.code;
          var errorMessage = error.message;

          console.log(errorCode);
          console.log(errorMessage);

          window.alert("Message : " + errorMessage);
        }
        else
        {
          window.location.href = "MainPage.html";
        }
      });
    }
    else
    {
      window.alert("Form is incomplete. Please fill up out all filds.");
    }
  });