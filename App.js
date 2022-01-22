/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React,{useEffect} from 'react';

import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';
import { NativeModules } from 'react-native';

function App() {
  //  var Tink = NativeModules.RCTTink;
    
    const onSubmit = () => {
      CalendarModule.createCalendarEvent(
        'Party',
        '04-12-2020',
        (eventId) => {
          console.log(`Created a new event with id ${eventId}`);
        }
      );
    };
    
    const { Tink } = NativeModules;
    useEffect(() => {
     fetchData();
     // onSubmit();
   }, []);
  /*  async function fetchData() {
      try {
        const Rkeys = await Tink.GenerateKeys();
        console.log(Rkeys);
        //  console.log(`Created a new event with id ${events}`);
        // this.setState({events});
      } catch (e) {
        console.log('Failed');
        console.log(e);
      }
    }
 */
   /* async function fetchData() {
          try {
            const Rkeys = await Tink.GenerateKeys();
            console.log(Rkeys);
            const private_key = "COyD8A4SuAEKrAEKNnR5cGUuZ29vZ2xlYXBpcy5jb20vZ29vZ2xlLmNyeXB0by50aW5rLkVjZHNhUHJpdmF0ZUtleRJwEkwSBggDEAIYAhogbeNjEPOhJX4AB+X166T3MLlzy1Ww28g0FigZ0ug+kwgiIClcyZgwthS3XzAvDtjOZkJxTBsAwx8FKG08HnDSAUXRGiAcylOaRfl4VD6z+et9wj2QRS6k0mwzeVKyCq07igtveBgCEAEY7IPwDiAB"
            const sign = await Tink.sign("React native project",private_key);
            console.log("Sign",sign)
            //You will get output like this =>
            //"AQHcAewwRQIhAPIblTP5BnUmDLFlIgsxpscBk7vqhpVPtsJtQUKgvgmmAiBPvTYEvCNPVhXaCOEF9omTEexBRu4YORSmLEVrAafVDg=="
           
              //This is boolean
                    const sign1="AQHcAewwRQIgbmAG7ENDK4Ci1mK+4rVALbbWCR+iMU+Aumw8mFE5UpgCIQDuew1IEb/uF8eUkR2B7A8M0JqWCW4ql8YLeIBoSuviVA=="
                    const spu ="COyD8A4SkwEKhwEKNXR5cGUuZ29vZ2xlYXBpcy5jb20vZ29vZ2xlLmNyeXB0by50aW5rLkVjZHNhUHVibGljS2V5EkwSBggDEAIYAhogbeNjEPOhJX4AB+X166T3MLlzy1Ww28g0FigZ0ug+kwgiIClcyZgwthS3XzAvDtjOZkJxTBsAwx8FKG08HnDSAUXRGAMQARjsg/AOIAE="
                    let sigvalid = await Tink.verifySignature1("React native project", sign1,spu);
                    console.log("sigvalid",sigvalid)
                    //You will get output like this =>
                    //true
                    const symkey = await Tink.generateSymmetricKey()
                    console.log("symkey",symkey)
                    //You will get output like this =>
                    // CKPDguYCElQKSAowdHlwZS5nb29nbGVhcGlzLmNvbS9nb29nbGUuY3J5cHRvLnRpbmsuQWVzR2NtS2V5EhIaEBx1TlKtQFdDny+33jvcG7cYARABGKPDguYCIAE=


                    const SymmetricKey = "CKPDguYCElQKSAowdHlwZS5nb29nbGVhcGlzLmNvbS9nb29nbGUuY3J5cHRvLnRpbmsuQWVzR2NtS2V5EhIaEBx1TlKtQFdDny+33jvcG7cYARABGKPDguYCIAE="

                    const encryptSymmetric1 = await Tink.encryptSymmetric1("React native project", SymmetricKey)
                    console.log("encryptSymmetric1", encryptSymmetric1)
          
          } catch (e) {
            console.log('Failed');
            console.log(e);
          }
        }*/
    async function fetchData() {
        try {
          const Rkeys = await Tink.getKeys();
          console.log("R-keys",Rkeys);
          const private_key = "COyD8A4SuAEKrAEKNnR5cGUuZ29vZ2xlYXBpcy5jb20vZ29vZ2xlLmNyeXB0by50aW5rLkVjZHNhUHJpdmF0ZUtleRJwEkwSBggDEAIYAhogbeNjEPOhJX4AB+X166T3MLlzy1Ww28g0FigZ0ug+kwgiIClcyZgwthS3XzAvDtjOZkJxTBsAwx8FKG08HnDSAUXRGiAcylOaRfl4VD6z+et9wj2QRS6k0mwzeVKyCq07igtveBgCEAEY7IPwDiAB"
          const sign = await Tink.sign("React native project", private_key);
          console.log("Sign", sign)
          //You will get output like this =>
          //"AQHcAewwRQIhAPIblTP5BnUmDLFlIgsxpscBk7vqhpVPtsJtQUKgvgmmAiBPvTYEvCNPVhXaCOEF9omTEexBRu4YORSmLEVrAafVDg=="

         //This is boolean
          const sign1="AQHcAewwRQIgbmAG7ENDK4Ci1mK+4rVALbbWCR+iMU+Aumw8mFE5UpgCIQDuew1IEb/uF8eUkR2B7A8M0JqWCW4ql8YLeIBoSuviVA=="
          const spu ="COyD8A4SkwEKhwEKNXR5cGUuZ29vZ2xlYXBpcy5jb20vZ29vZ2xlLmNyeXB0by50aW5rLkVjZHNhUHVibGljS2V5EkwSBggDEAIYAhogbeNjEPOhJX4AB+X166T3MLlzy1Ww28g0FigZ0ug+kwgiIClcyZgwthS3XzAvDtjOZkJxTBsAwx8FKG08HnDSAUXRGAMQARjsg/AOIAE="
          let sigvalid = await Tink.verifySignature1("React native project", sign1,spu);
          console.log("sigvalid",sigvalid)
          //You will get output like this =>
          //true

          //Their is nothing in input
          const symkey = await Tink.generateSymmetricKey()
          console.log("symkey",symkey)
          //You will get output like this =>
          // CKPDguYCElQKSAowdHlwZS5nb29nbGVhcGlzLmNvbS9nb29nbGUuY3J5cHRvLnRpbmsuQWVzR2NtS2V5EhIaEBx1TlKtQFdDny+33jvcG7cYARABGKPDguYCIAE=


          const SymmetricKey = "CKPDguYCElQKSAowdHlwZS5nb29nbGVhcGlzLmNvbS9nb29nbGUuY3J5cHRvLnRpbmsuQWVzR2NtS2V5EhIaEBx1TlKtQFdDny+33jvcG7cYARABGKPDguYCIAE="

          const encryptSymmetric1 = await Tink.encryptSymmetric1("React native project", SymmetricKey)
          console.log("encryptSymmetric1", encryptSymmetric1)
          //You will get output like this =>
          //ASzAoaPej0yv2dGl54eu3Qhs7Hc6lFj1Q4n+ClZrubBBBjjyBCauIPy9YTUDPObte3o=
          
          //For decryptSymmetric1 First input is encryptSymmetric1 and SymmetricKey
         const  decryptSymmetric1 =await Tink.decryptSymmetric1(encryptSymmetric1, SymmetricKey);
         console.log("decryptSymmetric1",decryptSymmetric1)
         //You will get output like this =>
          //React native project

          //first input is SymmetricKey
          const pu ="CNjkz+UHEtwBCs8BCj10eXBlLmdvb2dsZWFwaXMuY29tL2dvb2dsZS5jcnlwdG8udGluay5FY2llc0FlYWRIa2RmUHVibGljS2V5EosBEkQKBAgCEAMSOhI4CjB0eXBlLmdvb2dsZWFwaXMuY29tL2dvb2dsZS5jcnlwdG8udGluay5BZXNHY21LZXkSAhAQGAEYARogVhJFuPtXDz//ghjsH8AsgPEnz5Sn7EXpeGUO5zXxBXYiIQDA1l8it2TpeiSfzoRc+V2KzXwgpbz3Ymy2B53aGomG9hgDEAEY2OTP5QcgAQ=="
          const encryptHybrid1 = await Tink.encryptHybrid1(SymmetricKey,  pu)
          console.log("encryptHybrid1",encryptHybrid1)
          //You will get output like this =>
          //"AXyz8lgE57wOM0KanR8k7KXyoceOwku4DVV4KenF+4xB3IgR+L8BxIbInDOujXvtaYwbQvlKCEPJbbSMFHqqg/xseLyAqzUmS8qqTK3S8Y9WHDfcWXqCHN6+cc8tEdWdENQTkCSOb0lDmhiERgA7iNFfvaFJ4pENCy1XFfoWeoSEhy/6w/Wl7Nn3sV02EMZQSvwoXmsmjs6Tg9hbPRk/IWwCKoLuOhz5Fbe8JSrRPpraj/WZx5evjw4ghRuFZtJgTUX4I4a96oBldF0J/d2WXheY8ZeXMtSSYn4LNV4/"

          //first input is encryptHybrid1
          const pk ="CNjkz+UHEoICCvUBCj50eXBlLmdvb2dsZWFwaXMuY29tL2dvb2dsZS5jcnlwdG8udGluay5FY2llc0FlYWRIa2RmUHJpdmF0ZUtleRKwARKLARJECgQIAhADEjoSOAowdHlwZS5nb29nbGVhcGlzLmNvbS9nb29nbGUuY3J5cHRvLnRpbmsuQWVzR2NtS2V5EgIQEBgBGAEaIFYSRbj7Vw8//4IY7B/ALIDxJ8+Up+xF6XhlDuc18QV2IiEAwNZfIrdk6Xokn86EXPldis18IKW892Jstged2hqJhvYaIF/4DvSM5/4aSDiXgUxZfMruaejsbWmVjozS2s2Djq66GAIQARjY5M/lByAB"
          const decryptHybrid1= await Tink.decryptHybrid1(encryptHybrid1, pk);
          console.log("decryptHybrid1",decryptHybrid1)
          //You will get output like this =>
          //"CKPDguYCElQKSAowdHlwZS5nb29nbGVhcGlzLmNvbS9nb29nbGUuY3J5cHRvLnRpbmsuQWVzR2NtS2V5EhIaEBx1TlKtQFdDny+33jvcG7cYARABGKPDguYCIAE="
          //same as SymmetricKey
          
          for (let loopNum = 0;loopNum<10;loopNum++){
              console.log('inside for loop')
                   await Tink.sign(
        '5cf5f570aa36ee60b36df99e84d4ca005c295ed0af948dadc9bade1d5b4d8a75',
        'CJvr08wEErkBCqwBCjZ0eXBlLmdvb2dsZWFwaXMuY29tL2dvb2dsZS5jcnlwdG8udGluay5FY2RzYVByaXZhdGVLZXkScBJMEgYIAxACGAIaIHDByxJjpPSNV+90Bts30xlAF5dAjvQR2cGYHEXfDxCSIiArXNbr51nGE1iR6NY3ajmxVj293PEgBRH+ZKlbRnS9aBogPsdHxCcv9roZrEVEXuwBy96/ymKquawGDCUizZTEspEYAhABGJvr08wEIAE=',
      )
      .then(sigadd1 => {
        console.log('Sign by Nikhil---'+loopNum, sigadd1);
      });
      
      console.log("Loop number---",loopNum)
       }    
        } catch (e) {
          console.log('Failed');
          console.log(e);
        }
      }
  return (
    <View>
      <Text>HI This is react native</Text>
    </View>
     
  );
};

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;
