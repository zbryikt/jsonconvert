var jsonconvert,x$;jsonconvert={findArray:function(n){var r,t,o;if(Array.isArray(n))return n;if(typeof n!=typeof{})return null;for(r in n)if(t=n[r],o=this.findArray(t))return o;return[n]},simpleCSV:function(n){function r(n){return'"'+i[n]+'"'}var t,o,e,u,i,a,c;for(t="",n=this.findArray(n),o={},e=0,u=n.length;u>e;++e){i=n[e];for(a in i)o[a]=1}c=[];for(a in o)c.push(a);for(o=c,t+=o.map(function(n){return'"'+n+'"'}).join(",")+"\n",e=0,u=n.length;u>e;++e)i=n[e],t+=o.map(r).join(",")+"\n";return t}},x$=angular.module("main",[]),x$.controller("main",["$scope"].concat(function(n){return n.build=function(){var r;return r=new Blob([n.csv],{type:"text/csv"}),n.url=URL.createObjectURL(r),n.download="output",setTimeout(function(){return $("#download").attr("href",n.url)},0)},n.convert=function(){var r,t,o;try{return n.download=null,r=JSON.parse(n.json),t=jsonconvert.simpleCSV(r),n.csv=t,n.build()}catch(e){return o=e,n.csv=o.toString()}}}));