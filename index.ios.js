import React, {Component} from 'react';
import {
    View, Text, Navigator, AppRegistry, Image, StyleSheet, NativeEventEmitter, NativeModules,
} from 'react-native';
const {EventSender} = NativeModules;


var Sound = require('react-native-sound');
Sound.setCategory('PlayAndRecord');


export default class Introduction extends Component {
    constructor(props) {

        super(props);
        this.state = {

            bpm :0
        };

        const sub1 = eventEmitter.addListener('end_recording', this.switchToTagsScreen.bind(this));
        const sub2 = eventEmitter.addListener('start_recording', this.switchToRecordStartScreen.bind(this));
        const sub3 = eventEmitter.addListener('return_words', this.returnWords.bind(this));

        var intro = this;

        require('react-native').NativeModules.EventSender.setBridge();

        this._changeSlide = this.changeSlide.bind(this);
        this._onMomentumScrollEnd = this.onMomentumScrollEnd.bind(this);
        this._manageRenderFooter = this.manageRenderFooter.bind(this);
        this._warnPages = this.warnPages.bind(this);

    }
    returnWords(data) {

        let dataString = data;
        let datas = dataString.split(" ");

        var uniqueDatas = [];

        for (let i = 0; i < datas.length; i++) {

            if (uniqueDatas.indexOf(datas[i]) === -1) uniqueDatas.push(datas[i]);

        }

        if (uniqueDatas) {

            this.tagsToSet = uniqueDatas;

        }


    }

    switchToRecordStartScreen() {

    }

    //end of pulse and speech
    switchToTagsScreen(data) {
        this.fftCompute(data);
    }


    render() {


        this.styles = StyleSheet.create({
            container: {
                flex: 1,
                justifyContent: 'center',
                alignItems: 'center'
            },
            text: {
                color: '#7070ff'
            }
        });


        return (

            <View>
                <Text>Put your finger on your camera and torch</Text>
                <Text>{this.state.bpm}</Text>
            </View>

        );

    }

    componentWillMount() {
    }

    componentDidMount(){
        ReactNative.NativeModules.HeartBeatRecorder.startRecording();
    }

    componentWillUnmount() {
    }

    async fftCompute(data) {
        if (Array.isArray(data) && data.length !=0) {

            const fft = require('../math/fft');
            //var data =  [119.228,119.454,121.565,121.766,123.716,123.85,125.315,125.391,123.767,124.629,126.008,126.354,127.469,127.757,128.881,129.073,129.653,126.477,127.89,128.288,129.362,130.003,131.028,131.189,131.884,131.496,129.211,129.568,130.853,131.201,132.565,132.96,133.435,133.57,133.583,130.261,131.046,131.419,132.399,133.104,133.891,134.269,134.408,131.275,131.535,131.669,132.433,133.227,134.341,134.634,135.061,135.151,133.157,131.87,132.19,132.714,133.742,134.402,135.039,135.355,135.509,132.767,136.257,136.702,137.088,137.922,138.584,139.044,139.496,138.291,136.706,136.837,138.294,138.951,140.046,140.479,140.973,141.158,138.032,138.126,136.236,136.598,137.654,138.237,138.544,138.961,135.386,135.88,136.227,136.562,137.325,137.877,138.325,138.657,138.89,135.235,135.472,135.766,136.097,136.789,137.45,137.913,138.263,138.476,138.095,135.247,135.097,135.778,136.118,136.787,137.293,137.753,137.994,137.494,135.428,135.532,135.684,135.981,136.684,137.223,137.693,137.962,137.139,135.433,135.244,135.759,136.186,136.879,137.387,137.71,137.911,137.156,135.663,135.587,136.028,136.401,136.943,137.265,137.555,137.628,135.382,135.527,135.775,136.098,136.604,136.936,137.257,137.481,135.299,134.977,134.943,135.237,135.798,136.302,136.781,137.066,137.153,134.366,134.467,134.84,135.281,135.872,136.399,136.802,137.08,137.047,134.787,134.813,135.308,135.641,136.176,136.544,136.843,137.072,136.074,135.137,135.249,135.426,135.915,136.368,136.657,136.861,136.513,134.787,134.856,135.163,135.54,136.094,136.429,136.702,136.571,134.778,135.129,135.234,135.496,135.972,136.217,136.396,134.167,134.454,134.601,134.878,135.447,135.892,136.152,136.375,133.649,133.888,133.855,133.986,134.732,135.327,135.72,136.098,133.622,133.641,133.81,134.16,134.828,135.317,135.678,135.81,133.376,133.707,134.129,134.565,135.18,135.607,135.888,136.072,133.205,133.562,133.759,134.18,134.882,135.306,135.702];

            const data2 = new fft.ComplexArray(data.length).map((value, i, n) => {
                value.real = data[i];

            });
            data2.FFT();

            var spectrumPower = []
            data2.map((value, i, n) => {
                var power = Math.sqrt(value.real * value.real + value.imag * value.imag) / n;
                spectrumPower.push(power);
            });

            freqOffset = ((50 / 60) * (data.length)) / 9;
            discreteFreq = argmax(spectrumPower.slice(freqOffset, data.length / 2)) + freqOffset;
            hr = ((discreteFreq * 9) / data.length) * 60.;
            //console.log(hr);


            function argmax(obj, iterator, context) {
                var max = null, argmax = null, value;
                if (iterator) iterator = lookupIterator(iterator, context);
                for (var i = 0, length = obj.length; i < length; i++) {
                    value = iterator ? iterator(obj[i]) : obj[i];
                    if (max == null || value > max) {
                        max = value;
                        argmax = i;
                    }
                }
                return argmax;
            }

            //console.log("VALUE :", hr)
            this.centerPulseRef._updateBPM(hr.toFixed(0))

            //this.setState({pulse: Number(hr.toFixed(0))})
        }
        /*else if (!isNaN(data)) {
         this.setState({pulse: Number(data)})
         }*/

    }

}


AppRegistry.registerComponent('IRUS_V4', () => Introduction);
