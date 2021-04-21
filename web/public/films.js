var API = (() => {

    var jwtToken;
    var usernames = ["Liz"];

    var createFilm = (form) => {
        /*
            Gets the elements from the input boxes
            Sends films & ratings one at a time to server
            Request films from server to display as table in browser
        */

        var newFilm = form.film.value; //Gets film input from index.html
        var newRating = Number(form.rating.value); //Gets rating input from html

        //dissappears tbl if user decides to add more films
        if (document.getElementById("mytable").style.visibility == "visible") {
            document.getElementById("mytable").style.visibility = "invisible"; 
        }
        //---Checks for valid film and rating entries
        //Empty title check
        if (newFilm == null || newFilm == "") {
            alert("\nYou didn't enter a film.\nPlease enter a film before submitting.");
        }
        //Empty rating check
        else if (newRating == null || newRating == "") {
            alert("\nYou didn't enter a rating. \n Please enter a rating before submitting.");
        }
        //Valid rating entry check
        else if ([1,2,3,4,5].includes(newRating) == false) {
            alert("\nINVALID RATING ENTRY\nPlease enter a number 1-5 for how many stars you give this film.");
        }
        //Only posts if above checks pass
        else {
            const data = {name : newFilm, rating : newRating};
            try {
                fetch("http://10.0.0.133:8080/api/v1/films", {
                    method: 'POST',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ' + jwtToken
                    },
                    body: JSON.stringify(data),
                }).then(resp => {
                    setTimeout(function () {
                        if (resp.status == 200) {
                            alert("Success!!\nDo you have more to add? Once you've added all your films, hit \"Display films\" to view your summary."); //successful submission notification
                            console.log('Success:', data); //logs new db entry to console
                            form.reset(); //clears form for next input
                        } else {
                            alert("** Access Denied **\nPlease log in before entering new films.");
                            form.reset(); //clears form for next input
                        }
                    }, 0);
                }); 
            } catch (e) {
                console.log(e);
                console.log('----------------------------');
            }
        }
        return false;
    }
    
    var getFilms = () => {

        /*
            Gets the table
            For ea element in the array
            Add a row to the table
        */

        try {
            //fetch arg is the path to server, which returns a promise containing our JSON obj
            fetch("http://10.0.0.133:8080/api/v1/films", {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            // use json() method to extract JSON body content from the response
            }).then(resp => resp.json()) //after first promise is resolved, next promise ('.then call')
                .then(results => {

                    var tbl = document.getElementById("table"); //get table
                    tbl.innerHTML = "";

                    results.forEach(data => {
                        //iterates through array and appends row to table for ea film
                        
                            var row = tbl.insertRow(); //insert new row at end of table with current film
            
                            //create cells for ea row
                            var cell1 = row.insertCell(0); 
                            var cell2 = row.insertCell(1); 
            
                            //Dynamically fill film title *** Updated for Assignment 4 ***
                            cell1.innerHTML = data.name; 
                            if (data.rating == 1) {cell2.innerHTML = '✮'}
                            if (data.rating == 2) {cell2.innerHTML = '✮✮'}
                            if (data.rating == 3) {cell2.innerHTML = '✮✮✮'}
                            if (data.rating == 4) {cell2.innerHTML = '✮✮✮✮'}
                            if (data.rating == 5) {cell2.innerHTML = '✮✮✮✮✮'}                    

                        //only display table if > 1 film has been successfully submitted
                        if (data != '') {
                            document.getElementById("mytable").style.visibility = "visible"; 
                     //       document.getElementById("get-films-button").style.visibility = "hidden";
                     //       document.getElementById("submit-button").style.visibility = "hidden";
                        }  });
                });
        } catch (e) {
            console.log(e);
            console.log('-------------------');
        }

       return false;
    }

    var login = () => {

        const val = document.getElementById("login").value;

        if (val == null || val == "") {
            alert("\nYou didn't enter a username.\nPlease enter a username to log in.");
            loginForm.reset();
        } else if (usernames.includes(val)==false) {
            alert("\nInvalid username.\nPlease enter a username to log in.");
            loginForm.reset();
        } else {
            try {
                fetch("http://10.0.0.133:8080/api/v1/login", {
                    method: 'POST',
                    body: JSON.stringify({
                        username: val
                    }),
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                    }
                }).then(resp => resp.json())
                    .then(data => {
                        jwtToken = data.token;
                        //remove login elements
                        var toRemove = document.getElementById("login");
                        toRemove.parentNode.removeChild(toRemove);
                        var toRemove = document.getElementById("login-button");
                        toRemove.parentNode.removeChild(toRemove);
                        var toRemove = document.getElementById("login-label");
                        toRemove.parentNode.removeChild(toRemove);

                        alert("Welcome\nPlease enter your films, one at a time.");
                    }); 
        } catch (e) {
            console.log(e);
            console.log('-------------------');
        }}
        return false;
    }

    var updateFilm = (form) => {
        /*
            Gets the elements from the input boxes
            Sends films & ratings to server
            Updates films currently in database
        */

       var newFilm = form.film.value; //Gets film input from index.html
       var newRating = Number(form.rating.value); //Gets rating input from html

       //dissappears tbl if user decides to add more films
       if (document.getElementById("mytable").style.visibility == "visible") {
           document.getElementById("mytable").style.visibility = "invisible"; 
       }
       //---Checks for valid film and rating entries
       //Empty title check
       if (newFilm == null || newFilm == "") {
           alert("\nYou didn't enter a film.\nPlease enter a film before submitting.");
       }
       //Empty rating check
       else if (newRating == null || newRating == "") {
           alert("\nYou didn't enter a rating. \n Please enter a rating before submitting.");
       }
       //Valid rating entry check
       else if ([1,2,3,4,5].includes(newRating) == false) {
           alert("\nINVALID RATING ENTRY\nPlease enter a number 1-5 for how many stars you give this film.");
       }
       //Only posts if above checks pass
       else {
           const data = {name : newFilm, rating : newRating};
           try {
               fetch("http://10.0.0.133:8080/api/v1/films", {
                   method: 'PATCH',
                   headers: {
                       'Accept': 'application/json',
                       'Content-Type': 'application/json',
                       'Authorization': 'Bearer ' + jwtToken
                   },
                   body: JSON.stringify(data),
               }).then(resp => {
                   setTimeout(function () {
                       if (resp.status == 200) {
                           alert("Success!!\nDo you have more to add? Once you've added all your films, hit \"Display films\" to view your summary."); //successful submission notification
                           console.log('Success:', data); //logs new db entry to console
                           form.reset(); //clears form for next input
                       } else {
                           alert("** Access Denied **\nPlease log in before entering new films.");
                           form.reset(); //clears form for next input
                       }
                   }, 0);
               }); 
           } catch (e) {
               console.log(e);
               console.log('----------------------------');
           }
       }
       return false;
   }




    return {
        createFilm,
        getFilms,
        login,
        updateFilm,
    }

})();
