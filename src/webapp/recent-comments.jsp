<%@ include file="declarations.jsp"%>

<tolog:context topicmap="metadata.xtm">
<%@ include file="tolog.jsp"%>
<%@ include file="handleuser.jsp"%>
<tolog:if var="nouser">
  <jsp:forward page="hidden.jsp"/>
</tolog:if>

<template:insert template='template.jsp'>
<template:put name='title'>
Recent comments
</template:put>

<template:put name="body">

<table>
<%
  boolean showunapproved = username.equals("larsga");  
  Iterator it = CommentManager.getRecentComments(showunapproved).iterator();
  while (it.hasNext()) {
    CommentManager.Comment comment = (CommentManager.Comment) it.next();
    pageContext.setAttribute("comment", comment);
    String query = "$T = " + comment.getPhotoId() + "?";

    try {
%>
<tolog:set var="photo" query="<%= query %>"/>
<tr><td>
<a href="photo.jsp?id=<tolog:id var="photo"/>"><img src="<%= pageContext.getServletContext().getInitParameter("photo-server") %><tolog:id var="photo"/>;thumb" border="0"></a>

<td valign=top><span style="font-size: 75%"><tolog:out var="photo"/><br><br>

<b><c:out value="${comment.user}"/></b> - <c:out value="${comment.formattedDatetime}"/><br>
<c:out value="${comment.formattedContent}" escapeXml="false"/>

<c:if test='${(!comment.isVerified) && username == "larsga"}'>
  <a href="delete-comment.jsp?id=<c:out value="${comment.id}"/>"
     onclick="return confirmDelete('comment')"><img src="resources/remove.gif"></a>
  <a href="approve-comment.jsp?id=<c:out value="${comment.id}"/>"
     >OK</a>
</c:if>

<%
    } catch (net.ontopia.topicmaps.nav2.core.NavigatorRuntimeException e) {
      // means the photo was deleted
      // guess no output is needed
    }
 } %>
</table>

</template:put>
</template:insert>
</tolog:context>
