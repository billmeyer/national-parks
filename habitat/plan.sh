pkg_name=national-parks
pkg_description="A sample JavaEE Web app deployed in the Tomcat8 package"
pkg_origin=mwrock
pkg_version=0.1.5
pkg_maintainer="Bill Meyer <bill@chef.io>"
pkg_license=('Apache-2.0')
pkg_deps=(core/tomcat8 core/jdk8/8u131 core/mongo-tools)
pkg_build_deps=(core/maven)
pkg_expose=(8080)
pkg_svc_user="root"
pkg_binds=(
  [database]="port"
)

do_prepare()
{
    export JAVA_HOME=$(hab pkg path core/jdk8)
}

do_build()
{
    cp -r $PLAN_CONTEXT/../ $HAB_CACHE_SRC_PATH/$pkg_dirname
    cd ${HAB_CACHE_SRC_PATH}/${pkg_dirname}
    mvn package
}

do_install()
{
    local source_dir="${HAB_CACHE_SRC_PATH}/${pkg_dirname}"
    cp -v ${source_dir}/national-parks.json ${PREFIX}/
    cp ${source_dir}/target/${pkg_name}.war ${PREFIX}/
}
