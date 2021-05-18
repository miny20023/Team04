<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<body>
<table border="0">
    <tr><td>
        <input type="button" name="11" [안내]태그제한으로등록되지않습니다-xxonClick="fnSetImg('http://wstatic.naver.com/w/n_c600.gif');" value="이미지추가" class="EditorImg" />
    </td></tr>
    <tr><td>
        <textarea style="display：none" name="comment"></textarea>
        <iframe width="800" height="650" id="Editor"></iframe>
    </td></tr>
</table>
</body>

<script type="text/xxjavascript" language="xxjavascript">
    var fm= frames.Editor;
    fm.document.designMode = "ON";


 

    function fnSetImg(imgPath) {
        // 이미지 태그 삽입
        var str = "<img src="+ imgPath +" />";
        fm.focus();
        fm.document.selection.createRange().pasteHTML(str);
    }
</script>
</html>