<%@page session="true"%><%@taglib uri="http://www.springframework.org/tags" prefix="sp"%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%><html version="XHTML+RDFa 1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:foaf="http://xmlns.com/foaf/0.1/">
<head data-color="${colorPair}" profile="http://www.w3.org/1999/xhtml/vocab">
<title>${results.getTitle()}&mdash;LodView</title>
<jsp:include page="inc/header.jsp"></jsp:include>
</head>
<body id="top">
	<article>
		<div id="logoBanner">
			<div id="logo">
				<!-- placeholder for logo -->
			</div>
		</div>
		<header>
			<hgroup>
				<h1>
					<span>${results.getTitle()}</span>
				</h1>
				<h2>
					<a class="iri" href="${results.getMainIRI()}">${results.getMainIRI()}</a>
					<div id="seeOnLodlive" class="sp">
						<a title="view resource on lodlive" target="_blank" href="${lodliveUrl }"></a>
					</div>
				</h2>
			</hgroup>
			<div id="abstract">
				<label class="c1"> <c:forEach end="0" items='${results.getResources(results.getMainIRI()).get(results.getTypeProperty())}' var="el">
						<a title="&lt;${el.getValue()}&gt;" href="${el.getUrl()}" <c:if test="${!el.isLocal()}">target="_blank" </c:if>> <c:choose>
								<c:when test='${el.getNsValue().startsWith("null:")}'>&lt;${el.getValue().replaceAll("([#/])([^#/]+)$","$1<span>$2")}</span>&gt;</c:when>
								<c:otherwise>
									<span class="istanceOf">${el.getNsValue().replaceAll("([A-Z])"," $1").replaceAll(".+:","<span>")}</span>
								</c:otherwise>
							</c:choose>
						</a>
					</c:forEach>
				</label>
				<div class="c2 value">
					<c:choose>
						<c:when test="${results.getDescriptionProperty() != null}">
							<c:forEach items='${results.getLiterals(results.getMainIRI()).get(results.getDescriptionProperty())}' var="el">
								<div  >${el.getValue()}</div>
 
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div></div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</header>
		<c:set var="hasMap" scope="page" value='${results.getLatitude()!=null && !results.getLatitude().equals("") && results.getLongitude()!=null&&!results.getLongitude().equals("")}'></c:set>
		<c:set var="hasLod" scope="page" value="${results.getLinking()!=null && results.getLinking().size()>0}"></c:set>
		<c:choose>
			<c:when test='${(results.getImages()!=null && results.getImages().size()>0) || hasMap || hasLod}'>
				<%@include file="inc/widgets.jsp"%>
			</c:when>
			<c:otherwise>
				<aside class="empty"></aside>
			</c:otherwise>
		</c:choose>
		<%
			/* direct relations */
		%>
		<div id="directs">
			<%
				/* setting class names for colums */
			%>
			<c:set var="c1name" value="c1" scope="page"></c:set>
			<c:set var="c2name" value="c2" scope="page"></c:set>
			<c:set var="contentIRI" value="${results.getMainIRI()}" scope="page" />
			<%@include file="func/contents.jsp"%>

		</div>
		<c:choose>
			<c:when test="${results.getBnodes(results.getMainIRI())!=null && results.getBnodes(results.getMainIRI()).keySet().size()>0 }">
				<div id="bnodes">
					<h3>
						<sp:message code='title.blankNodes' text='blank nodes' />
					</h3>
					<%
						/* first level of blank nodes */
					%>
					<c:forEach items='${results.getBnodes(results.getMainIRI()).keySet()}' var="prop">
						<label class="c1"><a data-label="${prop.getLabel()}" data-comment="${prop.getComment()}" href="${prop.getPropertyUrl()}"><c:choose>
									<c:when test='${prop.getNsProperty().startsWith("null:")}'>&lt;${prop.getProperty().replaceAll("([#/])([^#/]+)$","$1<span>$2")}</span>&gt;</c:when>
									<c:otherwise>${prop.getNsProperty().replaceAll(":",":<span>")}</span>
									</c:otherwise>
								</c:choose></a></label>
						<div class="c2 valuecnt">
							<c:forEach items='${results.getBnodes(results.getMainIRI()).get(prop)}' var="iel">
								<div class="toOneLine">
									<a href="#t_${iel.getValue()}" id="${iel.getValue()}"> _:${iel.getValue()}</a>
								</div>
								<c:set var="c1name" value="c3" scope="page"></c:set>
								<c:set var="c2name" value="c4" scope="page"></c:set>
								<c:set var="contentIRI" value="${iel.getValue()}" scope="page" />
								<%@include file="func/contents.jsp"%>
							</c:forEach>
						</div>
					</c:forEach>

					<%
						/* second level of blank nodes */
					%>
					<c:forEach items='${results.getBnodes(results.getMainIRI()).keySet()}' var="prop1">
						<c:forEach items='${results.getBnodes(results.getMainIRI()).get(prop1)}' var="iel1">
							<c:set var="acontentIRI" value="${iel1.getValue()}" scope="page" />
							<c:forEach items='${results.getBnodes(acontentIRI).keySet()}' var="prop">
								<label class="c1"><a data-label="${prop.getLabel()}" data-comment="${prop.getComment()}"><c:choose>
											<c:when test='${prop.getNsProperty().startsWith("null:")}'>&lt;${prop.getProperty().replaceAll("([#/])([^#/]+)$","$1<span>$2")}</span>&gt;</c:when>
											<c:otherwise>${prop.getNsProperty().replaceAll(":",":<span>")}</span>
											</c:otherwise>
										</c:choose></a></label>
								<div class="c2 valuecnt">
									<c:forEach items='${results.getBnodes(acontentIRI).get(prop)}' var="iel">
										<div class="toOneLine">
											<a href="#t_${iel.getValue()}" id="${iel.getValue()}"> _:${iel.getValue()}</a>
										</div>
										<c:set var="c1name" value="c3" scope="page"></c:set>
										<c:set var="c2name" value="c4" scope="page"></c:set>
										<c:set var="contentIRI" value="${iel.getValue()}" scope="page" />
										<%@include file="func/contents.jsp"%>
									</c:forEach>
								</div>
							</c:forEach>
						</c:forEach>
					</c:forEach>

					<%
						/* third level of blank nodes */
					%>
					<c:forEach items='${results.getBnodes(results.getMainIRI()).keySet()}' var="prop1">
						<c:forEach items='${results.getBnodes(results.getMainIRI()).get(prop1)}' var="iel1">
							<c:forEach items='${results.getBnodes(iel1.getValue()).keySet()}' var="prop2">
								<c:forEach items='${results.getBnodes(iel1.getValue()).get(prop2)}' var="iel2">
									<c:set var="acontentIRI" value="${iel2.getValue()}" scope="page" />
									<c:forEach items='${results.getBnodes(acontentIRI).keySet()}' var="prop">
										<label class="c1"><a data-label="${prop.getLabel()}" data-comment="${prop.getComment()}" href="${prop.getPropertyUrl()}"><c:choose>
													<c:when test='${prop.getNsProperty().startsWith("null:")}'>&lt;${prop.getProperty().replaceAll("([#/])([^#/]+)$","$1<span>$2")}</span>&gt;</c:when>
													<c:otherwise>${prop.getNsProperty().replaceAll(":",":<span>")}</span>
													</c:otherwise>
												</c:choose></a></label>
										<div class="c2 valuecnt">
											<c:forEach items='${results.getBnodes(acontentIRI).get(prop)}' var="iel">
												<div class="toOneLine">
													<a href="#t_${iel.getValue()}" id="${iel.getValue()}"> _:${iel.getValue()}</a>
												</div>
												<c:set var="c1name" value="c3" scope="page"></c:set>
												<c:set var="c2name" value="c4" scope="page"></c:set>
												<c:set var="contentIRI" value="${iel.getValue()}" scope="page" />
												<%@include file="func/contents.jsp"%>
											</c:forEach>
										</div>
									</c:forEach>
								</c:forEach>
							</c:forEach>
						</c:forEach>
					</c:forEach>

				</div>
			</c:when>
			<c:otherwise>
				<div id="bnodes" class="empty"></div>
			</c:otherwise>
		</c:choose>
		<c:set var="c1name" value="c1" scope="page"></c:set>
		<c:set var="c2name" value="c2" scope="page"></c:set>
		<div id="inverses" class="empty"></div>
		<div id="lodCloud">
			<h3>
				<sp:message code='title.lodCloud' text='data from the linked data cloud' />
			</h3>
			<div class="masonry"></div>
		</div>
		<jsp:include page="inc/custom_footer.jsp"></jsp:include>
	</article>
	<jsp:include page="inc/footer.jsp"></jsp:include>
	<c:import url="inc/scripts.jsp"></c:import>
	<div id="loadPanel">
		<p id="lmessage">
			<span class="lloading"></span><span class="content">&nbsp;</span>
		</p>
	</div>
	<div id="navigator">
		<div class="up sp"></div>
		<div class="top sp"></div>
		<div class="down sp"></div>
	</div>
</body>
</html>