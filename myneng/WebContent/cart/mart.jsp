<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마트 위치 찾기</title>
</head>
<body bgcolor="#f0efea">
	<div id="search"
		style="width: 300px; height: 50px; text-align: center; vertical-align: middle;">

		위치 : <input type="text" id="pin" name="pin"
			placeholder="도로명주소 또는 지번" />
		<button onClick="move();" id="btn">검색</button>
		

	</div>
	<div id="map" style="width: 80%; height: 350px;"></div>

	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=38f737cd683fba62a56112bac69b4844&libraries=services"></script>
	<script type="text/javascript">
	
	function move() {
		//removeMarker();

		var search = document.getElementById('pin').value;
		var geocoder = new kakao.maps.services.Geocoder();
		geocoder.addressSearch(search,
				function(result, status) {
					if (status === kakao.maps.services.Status.OK) {
						var coords = new kakao.maps.LatLng(result[0].y,
								result[0].x);

						/* var marker = new kakao.maps.Marker({
							map : map,
							position : coords
						}); */
						map.setCenter(coords);
						map.setLevel(5);
						
						// 대형마트 검색
						ps.categorySearch('MT1', placesSearchCB, {
							useMapBounds : true
						});
					}
				})
		
				
	}
	
	
	</script>
	<script type="text/javascript">
		// 마커를 클릭하면 장소명을 표출할 인포윈도우 입니다
		var infowindow = new kakao.maps.InfoWindow({
			zIndex : 1
		});

		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
			center : new kakao.maps.LatLng(37.4810068, 126.952190), // 지도의 중심좌표
			level : 5
		// 지도의 확대 레벨
		};

		// 지도를 생성합니다    
		var map = new kakao.maps.Map(mapContainer, mapOption);

		// 장소 검색 객체를 생성합니다
		var ps = new kakao.maps.services.Places(map);

		
		// 대형마트 검색
		ps.categorySearch('MT1', placesSearchCB, {
			useMapBounds : true
		});
		
		// 키워드 검색 완료 시 호출되는 콜백함수 입니다
		function placesSearchCB(data, status, pagination) {
			if (status === kakao.maps.services.Status.OK) {
				if(data.length == 0) {
					map.setLevel(6);
				}
				for (var i = 0; i < data.length; i++) {
					//map.setLevel(5);
					displayMarker(data[i]);
				}
				//document.getElementById('test').innerHTML = data.length;
				
			}
		}

		// 지도에 마커를 표시하는 함수입니다
		function displayMarker(place) {
			// 마커를 생성하고 지도에 표시합니다
			var marker = new kakao.maps.Marker({
				map : map,
				position : new kakao.maps.LatLng(place.y, place.x)
			});

			// 마커에 클릭이벤트를 등록합니다
			kakao.maps.event.addListener(marker, 'mouseover', function() {
				// 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
				infowindow
						.setContent('<div style="padding:5px;font-size:12px;">'
								+ place.place_name + '</div>');
				infowindow.open(map, marker);
			});
		}
		
		function removeMarker() {
		    for ( var i = 0; i < markers.length; i++ ) {
		        markers[i].setMap(null);
		    }   
		    markers = [];
		}
		
		kakao.maps.event.addListener(map, 'center_changed', function() {
			//alert('center changed');
		    // 지도의  레벨을 얻어옵니다
		    var level = map.getLevel();

		    // 지도의 중심좌표를 얻어옵니다 
		    var latlng = map.getCenter(); 
		 // 대형마트 검색
			ps.categorySearch('MT1', placesSearchCB, {
				useMapBounds : true
			});

		});
		
		kakao.maps.event.addListener(map, 'dragend', function() {
		    //alert('change');
			
		});
	</script>
</body>
</html>